export enum WallType {
    BRICK = 0,
    STEEL = 1
}
export class Wall {
    x: number;
    y: number;
    width: number;
    height: number;
    type: WallType;
    isActive: boolean;
    constructor(x: number, y: number, type: WallType) {
        this.x = x;
        this.y = y;
        this.width = 48; // Per spec: 48x48
        this.height = 48;
        this.type = type;
        this.isActive = true;
    }
}
