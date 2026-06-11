import { BaseEntity } from './BaseEntity';
import { EntityType, TankType, GameConfig } from '../../common/Constants';

export class Bullet extends BaseEntity {
  shooterType: EntityType = EntityType.PLAYER_TANK;
  dx: number = 0;
  dy: number = 0;
  speed: number = GameConfig.BULLET_BASE_SPEED;
  damage: number = 1;
  canPenetrateSteel: boolean = false;

  constructor() {
    super(EntityType.BULLET);
    this.width = GameConfig.BULLET_WIDTH;
    this.height = GameConfig.BULLET_HEIGHT;
  }

  fire(x: number, y: number, dx: number, dy: number, shooterType: EntityType, penetrate: boolean = false): void {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.shooterType = shooterType;
    this.canPenetrateSteel = penetrate;
    this.active = true;
  }

  update(): void {
    this.x += this.dx * this.speed;
    this.y += this.dy * this.speed;
  }

  deactivate(): void {
    this.active = false;
  }
}
