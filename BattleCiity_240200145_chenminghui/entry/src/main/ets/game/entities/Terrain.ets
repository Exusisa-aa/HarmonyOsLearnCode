import { BaseEntity } from './BaseEntity';
import { EntityType, TerrainType } from '../../common/Constants';

export class Terrain extends BaseEntity {
  terrainType: TerrainType = TerrainType.EMPTY;
  destroyed: boolean = false; // Only for BRICK - marks for removal

  constructor(x: number, y: number, width: number, height: number, type: TerrainType) {
    super(EntityType.TERRAIN);
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.terrainType = type;
    this.active = type !== TerrainType.EMPTY;
  }

  isBlocking(): boolean {
    return (
      this.terrainType === TerrainType.BRICK ||
      this.terrainType === TerrainType.STEEL ||
      this.terrainType === TerrainType.BASE
    );
  }

  isWalkable(): boolean {
    return (
      this.terrainType === TerrainType.EMPTY
    );
  }

  markDestroyed(): void {
    if (this.terrainType === TerrainType.BRICK) {
      this.destroyed = true;
      this.active = false;
    }
  }

  canBeDestroyed(): boolean {
    return this.terrainType === TerrainType.BRICK;
  }

  isSteel(): boolean {
    return this.terrainType === TerrainType.STEEL;
  }

  isBase(): boolean {
    return this.terrainType === TerrainType.BASE;
  }
}
