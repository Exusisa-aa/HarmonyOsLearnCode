import { GameEntity } from './GameEntity';
import { RenderLayer } from '../engine/CanvasRenderer';

export class Explosion {
  x: number;
  y: number;
  timer: number;

  constructor(x: number, y: number, timer: number) {
    this.x = x;
    this.y = y;
    this.timer = timer;
  }
}
