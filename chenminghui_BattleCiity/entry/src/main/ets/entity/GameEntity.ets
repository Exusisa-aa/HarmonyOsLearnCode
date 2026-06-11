import { RenderLayer, Renderable } from '../engine/CanvasRenderer';

export enum Direction {
  UP, RIGHT, DOWN, LEFT
}

export abstract class GameEntity implements Renderable {
  x: number;
  y: number;
  width: number;
  height: number;
  isActive: boolean;
  layer: RenderLayer = RenderLayer.TANKS;

  constructor(x: number, y: number, width: number, height: number) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.isActive = true;
  }

  get centerX(): number { return this.x + this.width / 2; }
  get centerY(): number { return this.y + this.height / 2; }

  abstract update(dt: number): void;
  abstract render(ctx: CanvasRenderingContext2D): void;

  collidesWith(other: GameEntity): boolean {
    return (
      this.x < other.x + other.width &&
      this.x + this.width > other.x &&
      this.y < other.y + other.height &&
      this.y + this.height > other.y
    );
  }
}
