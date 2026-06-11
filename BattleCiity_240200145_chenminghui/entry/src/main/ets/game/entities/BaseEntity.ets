import { EntityType } from '../../common/Constants';

export class AABB {
  x: number;
  y: number;
  width: number;
  height: number;

  constructor(x: number, y: number, width: number, height: number) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
}

export abstract class BaseEntity {
  x: number = 0;
  y: number = 0;
  width: number = 0;
  height: number = 0;
  active: boolean = true;
  entityType: EntityType;

  constructor(entityType: EntityType) {
    this.entityType = entityType;
  }

  getAABB(): AABB {
    return new AABB(this.x, this.y, this.width, this.height);
  }

  collidesWith(other: BaseEntity): boolean {
    const a = this.getAABB();
    const b = other.getAABB();
    return (
      a.x < b.x + b.width &&
      a.x + a.width > b.x &&
      a.y < b.y + b.height &&
      a.y + a.height > b.y
    );
  }

  setPosition(x: number, y: number): void {
    this.x = x;
    this.y = y;
  }

  setSize(width: number, height: number): void {
    this.width = width;
    this.height = height;
  }

  centerX(): number {
    return this.x + this.width / 2;
  }

  centerY(): number {
    return this.y + this.height / 2;
  }
}
