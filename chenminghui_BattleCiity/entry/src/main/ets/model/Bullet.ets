export enum BulletOwner {
  PLAYER,
  ENEMY
}

export class Bullet {
  x: number;
  y: number;
  width: number;
  height: number;
  vx: number;
  vy: number;
  owner: BulletOwner;
  isActive: boolean;
  speed: number = 10;

  constructor(x: number, y: number, vx: number, vy: number, owner: BulletOwner) {
    this.x = x;
    this.y = y;
    this.width = 10; // Per spec: Diameter 10px
    this.height = 10;
    this.vx = vx;
    this.vy = vy;
    this.owner = owner;
    this.isActive = true;
  }

  move() {
    this.x += this.vx * this.speed;
    this.y += this.vy * this.speed;
  }
}
