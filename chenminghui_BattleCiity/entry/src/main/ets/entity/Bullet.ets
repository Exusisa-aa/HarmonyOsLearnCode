import { GameEntity } from './GameEntity';
import { BULLET_SIZE, BULLET_SPEED } from '../util/Constants';
import { RenderLayer } from '../engine/CanvasRenderer';

export enum BulletOwner {
  PLAYER, ENEMY
}

export class Bullet extends GameEntity {
  vx: number;
  vy: number;
  owner: BulletOwner;
  canBreakSteel: boolean;

  constructor(x: number, y: number, vx: number, vy: number, owner: BulletOwner) {
    super(x, y, BULLET_SIZE, BULLET_SIZE);
    this.vx = vx;
    this.vy = vy;
    this.owner = owner;
    this.canBreakSteel = false;
    this.layer = RenderLayer.BULLETS;
  }

  update(dt: number): void {
    this.x += this.vx * BULLET_SPEED;
    this.y += this.vy * BULLET_SPEED;
  }

  render(ctx: CanvasRenderingContext2D): void {
    const bx = this.x + BULLET_SIZE / 2;
    const by = this.y + BULLET_SIZE / 2;

    // Trailing glow
    ctx.fillStyle = '#FF4500';
    ctx.beginPath();
    ctx.arc(bx - this.vx * 3, by - this.vy * 3, 4, 0, Math.PI * 2);
    ctx.fill();

    // Bullet body
    ctx.fillStyle = this.canBreakSteel ? '#FFD700' : '#FFFFFF';
    ctx.beginPath();
    ctx.arc(bx, by, 3, 0, Math.PI * 2);
    ctx.fill();
  }
}
