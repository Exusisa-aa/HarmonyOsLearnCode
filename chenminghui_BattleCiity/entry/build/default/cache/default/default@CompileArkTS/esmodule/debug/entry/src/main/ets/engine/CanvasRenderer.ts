import { CANVAS_WIDTH, CANVAS_HEIGHT, COLOR_BG } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
import type { ScaleInfo } from '../util/Types';
export enum RenderLayer {
    TERRAIN = 0,
    ITEMS = 1,
    BULLETS = 2,
    TANKS = 3,
    EFFECTS = 4,
    BASE = 5
}
export interface Renderable {
    render(ctx: CanvasRenderingContext2D): void;
    layer: RenderLayer;
}
export class CanvasRenderer {
    private ctx: CanvasRenderingContext2D | null = null;
    private scaleX: number = 1;
    private scaleY: number = 1;
    private entities: Renderable[] = [];
    bindContext(ctx: CanvasRenderingContext2D): void {
        this.ctx = ctx;
    }
    setScale(sx: number, sy: number): void {
        this.scaleX = sx;
        this.scaleY = sy;
    }
    getScale(): ScaleInfo {
        const info: ScaleInfo = { x: this.scaleX, y: this.scaleY };
        return info;
    }
    addEntity(entity: Renderable): void {
        this.entities.push(entity);
    }
    clearEntities(): void {
        this.entities = [];
    }
    removeEntity(entity: Renderable): void {
        const idx: number = this.entities.indexOf(entity);
        if (idx !== -1) {
            this.entities.splice(idx, 1);
        }
    }
    render(): void {
        if (!this.ctx)
            return;
        this.ctx.save();
        this.ctx.scale(this.scaleX, this.scaleY);
        this.ctx.fillStyle = COLOR_BG;
        this.ctx.fillRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
        const sorted: Renderable[] = [];
        const order: RenderLayer[] = [RenderLayer.TERRAIN, RenderLayer.ITEMS, RenderLayer.BULLETS,
            RenderLayer.TANKS, RenderLayer.EFFECTS, RenderLayer.BASE];
        for (const layer of order) {
            for (const entity of this.entities) {
                if (entity.layer === layer) {
                    sorted.push(entity);
                }
            }
        }
        for (const entity of sorted) {
            entity.render(this.ctx);
        }
        this.ctx.restore();
    }
}
