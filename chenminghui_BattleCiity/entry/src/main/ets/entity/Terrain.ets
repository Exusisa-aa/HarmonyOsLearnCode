import { GameEntity } from './GameEntity';
import { TILE_SIZE, COLOR_BRICK, COLOR_STEEL, COLOR_STEEL_DARK, COLOR_WATER, COLOR_FOREST, COLOR_ICE, COLOR_BASE_EAGLE } from '../util/Constants';
import { RenderLayer } from '../engine/CanvasRenderer';

export enum TileType {
  EMPTY = 0,
  BRICK = 1,
  STEEL = 2,
  WATER = 3,
  FOREST = 4,
  ICE = 5,
  BASE = 6,
  BASE_WALL = 7
}

export class Terrain extends GameEntity {
  tileType: TileType;

  constructor(x: number, y: number, type: TileType) {
    super(x, y, TILE_SIZE, TILE_SIZE);
    this.tileType = type;
    this.isActive = (type !== TileType.EMPTY);
    this.layer = type === TileType.FOREST ? RenderLayer.EFFECTS : RenderLayer.TERRAIN;
  }

  get isSolid(): boolean {
    return this.tileType === TileType.BRICK || this.tileType === TileType.STEEL ||
           this.tileType === TileType.BASE_WALL || this.tileType === TileType.BASE;
  }

  get isDestructible(): boolean {
    return this.tileType === TileType.BRICK || this.tileType === TileType.BASE_WALL;
  }

  get isWater(): boolean { return this.tileType === TileType.WATER; }
  get isIce(): boolean { return this.tileType === TileType.ICE; }
  get isForest(): boolean { return this.tileType === TileType.FOREST; }
  get isBase(): boolean { return this.tileType === TileType.BASE; }

  update(_dt: number): void {}

  render(ctx: CanvasRenderingContext2D): void {
    const px: number = this.x;
    const py: number = this.y;
    const pw: number = this.width;
    const ph: number = this.height;
    const pt: TileType = this.tileType;
    if (!this.isActive && pt !== TileType.ICE) return;

    switch (pt) {
      case TileType.BRICK:
      case TileType.BASE_WALL:
        ctx.fillStyle = COLOR_BRICK;
        ctx.fillRect(px, py, pw, ph);
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(px, py + ph / 2 - 2, pw, 4);
        ctx.fillRect(px + pw / 2 - 2, py, 4, ph);
        ctx.fillStyle = '#882200';
        ctx.fillRect(px + pw / 2 - 4, py + ph / 2 - 4, 4, 4);
        ctx.fillRect(px + pw - 4, py + ph - 4, 4, 4);
        ctx.fillRect(px + pw / 2 - 4, py + ph - 4, 4, 4);
        ctx.fillRect(px + pw - 4, py + ph / 2 - 4, 4, 4);
        break;
      case TileType.STEEL:
        ctx.fillStyle = COLOR_STEEL;
        ctx.fillRect(px, py, pw, ph);
        ctx.fillStyle = COLOR_STEEL_DARK;
        ctx.fillRect(px + 4, py + 4, pw - 8, ph - 8);
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(px + 8, py + 8, 8, 8);
        break;
      case TileType.WATER:
        ctx.fillStyle = COLOR_WATER;
        ctx.fillRect(px, py, pw, ph);
        ctx.fillStyle = '#2A2AAA';
        for (let i = 0; i < 3; i++) {
          ctx.fillRect(px + 4 + i * 16, py + 12, 8, 4);
        }
        break;
      case TileType.FOREST:
        ctx.fillStyle = COLOR_FOREST;
        ctx.fillRect(px, py, pw, ph);
        ctx.fillStyle = '#0C800C';
        ctx.beginPath();
        ctx.arc(px + pw / 4, py + ph / 2, pw / 4, 0, Math.PI * 2);
        ctx.fill();
        ctx.beginPath();
        ctx.arc(px + 3 * pw / 4, py + ph / 2, pw / 4, 0, Math.PI * 2);
        ctx.fill();
        break;
      case TileType.ICE:
        ctx.fillStyle = COLOR_ICE;
        ctx.fillRect(px, py, pw, ph);
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(px + 4, py + 4, pw - 8, 2);
        ctx.fillRect(px + 4, py + 20, pw - 8, 2);
        break;
      case TileType.BASE:
        this.drawEagle(ctx, px, py, pw, ph);
        break;
    }
  }

  private drawEagle(ctx: CanvasRenderingContext2D, ex: number, ey: number, ew: number, eh: number): void {
    ctx.fillStyle = '#222222';
    ctx.fillRect(ex, ey, ew, eh);
    ctx.fillStyle = COLOR_BASE_EAGLE;
    ctx.beginPath();
    ctx.arc(ex + ew / 2, ey + eh / 2 - 6, 6, 0, Math.PI * 2);
    ctx.fill();
    ctx.beginPath();
    ctx.moveTo(ex + ew / 2 - 4, ey + eh / 2);
    ctx.lineTo(ex + ew / 2 + 4, ey + eh / 2);
    ctx.lineTo(ex + ew / 2 + 6, ey + eh - 10);
    ctx.lineTo(ex + ew / 2 - 6, ey + eh - 10);
    ctx.fill();
    ctx.beginPath();
    ctx.moveTo(ex + ew / 2 - 4, ey + eh / 2 + 2);
    ctx.lineTo(ex + 8, ey + 8);
    ctx.lineTo(ex + 6, ey + eh / 2 + 4);
    ctx.lineTo(ex + ew / 2 - 6, ey + eh - 12);
    ctx.fill();
    ctx.beginPath();
    ctx.moveTo(ex + ew / 2 + 4, ey + eh / 2 + 2);
    ctx.lineTo(ex + ew - 8, ey + 8);
    ctx.lineTo(ex + ew - 6, ey + eh / 2 + 4);
    ctx.lineTo(ex + ew / 2 + 6, ey + eh - 12);
    ctx.fill();
    ctx.fillStyle = '#FF0000';
    ctx.fillRect(ex + ew / 2 - 3, ey + eh / 2 - 8, 2, 2);
    ctx.fillRect(ex + ew / 2 + 1, ey + eh / 2 - 8, 2, 2);
  }
}

export function charToTileType(ch: string): TileType {
  switch (ch) {
    case '#': return TileType.BRICK;
    case '@': return TileType.STEEL;
    case '~': return TileType.WATER;
    case 'F': return TileType.FOREST;
    case 'I': return TileType.ICE;
    case '&': return TileType.BASE_WALL;
    case 'B': return TileType.BASE;
    default:  return TileType.EMPTY;
  }
}
