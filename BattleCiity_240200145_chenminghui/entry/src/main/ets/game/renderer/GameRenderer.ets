import { Terrain } from '../entities/Terrain';
import { Tank } from '../entities/Tank';
import { PlayerTank } from '../entities/PlayerTank';
import { EnemyTank } from '../entities/EnemyTank';
import { Bullet } from '../entities/Bullet';
import { PowerUp } from '../entities/PowerUp';
import {
  TerrainType, TankType, PowerUpType,
  Direction, EntityType, GameConfig,
} from '../../common/Constants';

interface Rect {
  x: number;
  y: number;
  w: number;
  h: number;
}

export class GameRenderer {
  private ctx: CanvasRenderingContext2D;
  private mapPixelW: number;
  private mapPixelH: number;
  private scaleX: number = 1;
  private scaleY: number = 1;
  private offsetX: number = 0;
  private offsetY: number = 0;

  // Dirty rectangles
  private dirtyRects: Rect[] = [];
  private useDirtyRect: boolean = false;

  // Explosion effects
  private explosions: ExplosionEffect[] = [];

  constructor(ctx: CanvasRenderingContext2D) {
    this.ctx = ctx;
    this.mapPixelW = GameConfig.MAP_COLS * GameConfig.TILE_SIZE;
    this.mapPixelH = GameConfig.MAP_ROWS * GameConfig.TILE_SIZE;
    this.calculateTransform();
  }

  // --- Coordinate transform (task 10.8) ---
  private calculateTransform(): void {
    const screenW = this.ctx.width;
    const screenH = this.ctx.height;

    // Calculate scale to fit map on screen while maintaining aspect ratio
    const scaleX = screenW / this.mapPixelW;
    const scaleY = screenH / this.mapPixelH;
    const scale = Math.min(scaleX, scaleY);

    this.scaleX = scale;
    this.scaleY = scale;

    // Center the map
    const scaledW = this.mapPixelW * scale;
    const scaledH = this.mapPixelH * scale;
    this.offsetX = (screenW - scaledW) / 2;
    this.offsetY = (screenH - scaledH) / 2;
  }

  toScreenX(mapX: number): number {
    return mapX * this.scaleX + this.offsetX;
  }

  toScreenY(mapY: number): number {
    return mapY * this.scaleY + this.offsetY;
  }

  toScreenW(mapW: number): number {
    return mapW * this.scaleX;
  }

  toScreenH(mapH: number): number {
    return mapH * this.scaleY;
  }

  // --- Main render dispatch (task 10.1) ---
  beginFrame(): void {
    if (!this.useDirtyRect) {
      this.ctx.fillStyle = '#000000';
      this.ctx.fillRect(0, 0, this.ctx.width, this.ctx.height);
    } else {
      // Only clear dirty areas
      for (const rect of this.dirtyRects) {
        this.ctx.fillStyle = '#000000';
        this.ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
      }
    }
    this.dirtyRects = [];
  }

  addDirtyRect(mapX: number, mapY: number, mapW: number, mapH: number): void {
    if (!this.useDirtyRect) return;
    this.dirtyRects.push({
      x: this.toScreenX(mapX),
      y: this.toScreenY(mapY),
      w: this.toScreenW(mapW),
      h: this.toScreenH(mapH),
    });
  }

  // --- Terrain drawing (task 10.2) ---
  drawTerrain(terrain: Terrain): void {
    if (!terrain.active) return;

    const sx = this.toScreenX(terrain.x);
    const sy = this.toScreenY(terrain.y);
    const sw = this.toScreenW(terrain.width);
    const sh = this.toScreenH(terrain.height);

    const ctx = this.ctx;

    switch (terrain.terrainType) {
      case TerrainType.BRICK:
        ctx.fillStyle = '#B85C38';
        ctx.fillRect(sx, sy, sw, sh);
        // Brick lines
        ctx.strokeStyle = '#8B3A1A';
        ctx.lineWidth = 1;
        const midY = sy + sh / 2;
        ctx.beginPath();
        ctx.moveTo(sx, midY);
        ctx.lineTo(sx + sw, midY);
        ctx.stroke();
        const midX1 = sx + sw / 3;
        const midX2 = sx + sw * 2 / 3;
        ctx.beginPath();
        ctx.moveTo(midX1, sy);
        ctx.lineTo(midX1, midY);
        ctx.moveTo(midX2, midY);
        ctx.lineTo(midX2, sy + sh);
        ctx.stroke();
        break;

      case TerrainType.STEEL:
        ctx.fillStyle = '#B0B0B0';
        ctx.fillRect(sx, sy, sw, sh);
        ctx.strokeStyle = '#808080';
        ctx.lineWidth = 1;
        ctx.strokeRect(sx + 1, sy + 1, sw - 2, sh - 2);
        // Cross pattern
        ctx.beginPath();
        ctx.moveTo(sx, sy);
        ctx.lineTo(sx + sw, sy + sh);
        ctx.moveTo(sx + sw, sy);
        ctx.lineTo(sx, sy + sh);
        ctx.stroke();
        break;

      case TerrainType.WATER:
        ctx.fillStyle = '#1A1A8A';
        ctx.fillRect(sx, sy, sw, sh);
        // Water ripple lines
        ctx.strokeStyle = '#3333CC';
        ctx.lineWidth = 1;
        for (let i = 2; i < sh; i += 4) {
          ctx.beginPath();
          ctx.moveTo(sx, sy + i);
          ctx.lineTo(sx + sw, sy + i);
          ctx.stroke();
        }
        break;

      case TerrainType.TREE:
        ctx.fillStyle = '#0A3D0A';
        ctx.fillRect(sx, sy, sw, sh);
        ctx.fillStyle = '#228B22';
        const pad = sw * 0.15;
        ctx.fillRect(sx + pad, sy + pad, sw - pad * 2, sh - pad * 2);
        break;

      case TerrainType.BASE:
        ctx.fillStyle = '#FFD700';
        ctx.fillRect(sx, sy, sw, sh);
        // Eagle/flame pattern
        ctx.fillStyle = '#FF6600';
        ctx.fillRect(sx + sw * 0.3, sy + sh * 0.1, sw * 0.4, sh * 0.3);
        ctx.strokeStyle = '#CC0000';
        ctx.lineWidth = 1;
        ctx.strokeRect(sx + 1, sy + 1, sw - 2, sh - 2);
        break;
    }
  }

  // --- Tank drawing (task 10.3) ---
  drawTank(tank: Tank): void {
    if (!tank.active) return;

    const cx = this.toScreenX(tank.centerX());
    const cy = this.toScreenY(tank.centerY());
    const sw = this.toScreenW(tank.width);
    const sh = this.toScreenH(tank.height);

    const ctx = this.ctx;
    ctx.save();
    ctx.translate(cx, cy);

    // Rotate based on direction
    let angle = 0;
    switch (tank.direction) {
      case Direction.UP: angle = 0; break;
      case Direction.RIGHT: angle = Math.PI / 2; break;
      case Direction.DOWN: angle = Math.PI; break;
      case Direction.LEFT: angle = -Math.PI / 2; break;
    }
    ctx.rotate(angle);

    const hw = sw / 2;
    const hh = sh / 2;

    // Determine color based on tank type
    let bodyColor = '#00FF00';
    if (tank instanceof PlayerTank) {
      bodyColor = '#00FF00';
    } else if (tank instanceof EnemyTank) {
      switch (tank.tankType) {
        case TankType.NORMAL: bodyColor = '#FF4444'; break;
        case TankType.FAST: bodyColor = '#FF8800'; break;
        case TankType.HEAVY: bodyColor = '#888888'; break;
      }
    }

    // Special visual for power-up effects on player
    if (tank instanceof PlayerTank) {
      if (tank.invincible) {
        bodyColor = '#FFFFFF';
      } else if (tank.shieldActive) {
        ctx.strokeStyle = '#4488FF';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.arc(0, 0, Math.max(hw, hh) + 3, 0, Math.PI * 2);
        ctx.stroke();
      }
    }

    // Tank body
    ctx.fillStyle = bodyColor;
    ctx.fillRect(-hw, -hh, sw, sh);

    // Tank treads
    ctx.fillStyle = '#333333';
    ctx.fillRect(-hw, -hh, hw * 0.3, sh);
    ctx.fillRect(hw * 0.7, -hh, hw * 0.3, sh);

    // Turret (barrel)
    ctx.fillStyle = bodyColor;
    const barrelW = hw * 0.4;
    const barrelH = hh * 2.2;
    ctx.fillRect(-barrelW / 2, -barrelH, barrelW, barrelH);

    ctx.restore();
  }

  // --- Bullet drawing (task 10.4) ---
  drawBullet(bullet: Bullet): void {
    if (!bullet.active) return;

    const sx = this.toScreenX(bullet.x);
    const sy = this.toScreenY(bullet.y);
    const sw = this.toScreenW(bullet.width);
    const sh = this.toScreenH(bullet.height);

    const ctx = this.ctx;

    // Bullet body
    ctx.fillStyle = bullet.shooterType === EntityType.PLAYER_TANK ? '#FFFF00' : '#FF4444';
    ctx.fillRect(sx, sy, sw, sh);

    // Trail effect
    ctx.globalAlpha = 0.3;
    const trailX = sx - bullet.dx * sw * 3;
    const trailY = sy - bullet.dy * sh * 3;
    ctx.fillRect(trailX, trailY, sw, sh);
    ctx.globalAlpha = 1;
  }

  // --- Power-up drawing (task 10.5) ---
  drawPowerUp(powerUp: PowerUp): void {
    if (!powerUp.active) return;

    const now = Date.now();
    // Blink if about to expire
    if (powerUp.shouldBlink(now)) {
      const blinkPhase = Math.floor(now / 200) % 2;
      if (blinkPhase === 0) return;
    }

    const sx = this.toScreenX(powerUp.x);
    const sy = this.toScreenY(powerUp.y);
    const sw = this.toScreenW(powerUp.width);
    const sh = this.toScreenH(powerUp.height);
    const cx = sx + sw / 2;
    const cy = sy + sh / 2;

    const ctx = this.ctx;

    // Glow effect
    ctx.save();
    ctx.globalAlpha = 0.3;
    ctx.fillStyle = this.getPowerUpColor(powerUp.powerUpType);
    ctx.beginPath();
    ctx.arc(cx, cy, Math.max(sw, sh) * 0.8, 0, Math.PI * 2);
    ctx.fill();
    ctx.globalAlpha = 1;
    ctx.restore();

    // Icon background
    ctx.fillStyle = this.getPowerUpColor(powerUp.powerUpType);
    ctx.fillRect(sx, sy, sw, sh);
    ctx.strokeStyle = '#FFFFFF';
    ctx.lineWidth = 1;
    ctx.strokeRect(sx, sy, sw, sh);

    // Icon letter
    ctx.fillStyle = '#FFFFFF';
    ctx.font = `${Math.floor(sw * 0.6)}px sans-serif`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(this.getPowerUpLetter(powerUp.powerUpType), cx, cy);
  }

  private getPowerUpColor(type: PowerUpType): string {
    switch (type) {
      case PowerUpType.SPEED: return '#00FFAA';
      case PowerUpType.SHIELD: return '#4488FF';
      case PowerUpType.FIREPOWER: return '#FF4444';
      case PowerUpType.BASE_REINFORCE: return '#FFD700';
    }
  }

  private getPowerUpLetter(type: PowerUpType): string {
    switch (type) {
      case PowerUpType.SPEED: return 'S';
      case PowerUpType.SHIELD: return 'D';
      case PowerUpType.FIREPOWER: return 'F';
      case PowerUpType.BASE_REINFORCE: return 'B';
    }
  }

  // --- Explosion effects (task 10.6) ---
  spawnExplosion(mapX: number, mapY: number): void {
    this.explosions.push({
      x: mapX,
      y: mapY,
      particles: this.createExplosionParticles(12),
      age: 0,
      duration: 500,
    });
  }

  private createExplosionParticles(count: number): Particle[] {
    const particles: Particle[] = [];
    for (let i = 0; i < count; i++) {
      const angle = Math.random() * Math.PI * 2;
      const speed = 1 + Math.random() * 3;
      particles.push({
        dx: Math.cos(angle) * speed,
        dy: Math.sin(angle) * speed,
        life: 300 + Math.random() * 300,
        color: Math.random() > 0.5 ? '#FF6600' : '#FFCC00',
      });
    }
    return particles;
  }

  updateExplosions(deltaMs: number): void {
    for (const exp of this.explosions) {
      exp.age += deltaMs;
      for (const p of exp.particles) {
        p.life -= deltaMs;
      }
    }
    this.explosions = this.explosions.filter(e => e.age < e.duration);
  }

  drawExplosions(): void {
    const ctx = this.ctx;
    for (const exp of this.explosions) {
      const progress = exp.age / exp.duration;
      for (const p of exp.particles) {
        if (p.life <= 0) continue;
        const px = this.toScreenX(exp.x + p.dx * exp.age * 0.02);
        const py = this.toScreenY(exp.y + p.dy * exp.age * 0.02);
        const size = this.toScreenW(3) * (1 - progress);
        ctx.globalAlpha = p.life / 300;
        ctx.fillStyle = p.color;
        ctx.fillRect(px, py, size, size);
      }
    }
    ctx.globalAlpha = 1;
  }

  // --- Rendering pass ---
  drawAll(
    terrains: Terrain[],
    playerTanks: PlayerTank[],
    enemyTanks: EnemyTank[],
    bullets: Bullet[],
    powerUps: PowerUp[],
  ): void {
    this.beginFrame();

    for (const t of terrains) this.drawTerrain(t);
    for (const p of powerUps) this.drawPowerUp(p);
    for (const b of bullets) this.drawBullet(b);
    for (const e of enemyTanks) this.drawTank(e);
    for (const p of playerTanks) this.drawTank(p);
    this.drawExplosions();
  }

  // --- Debug: FPS display ---
  drawFPS(fps: number): void {
    const ctx = this.ctx;
    ctx.fillStyle = '#FFFF00';
    ctx.font = '12px monospace';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'top';
    ctx.fillText(`FPS: ${fps}`, 10, 10);
  }
}

interface Particle {
  dx: number;
  dy: number;
  life: number;
  color: string;
}

interface ExplosionEffect {
  x: number;
  y: number;
  particles: Particle[];
  age: number;
  duration: number;
}
