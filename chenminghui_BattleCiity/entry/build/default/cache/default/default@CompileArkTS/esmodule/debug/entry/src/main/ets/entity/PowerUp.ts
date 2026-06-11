import { GameEntity } from "@bundle:com.example.battlecity/entry/ets/entity/GameEntity";
import { POWERUP_SIZE, POWERUP_BLINK_START, POWERUP_LIFETIME } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
import { RenderLayer } from "@bundle:com.example.battlecity/entry/ets/engine/CanvasRenderer";
export enum PowerUpType {
    SPEED = // Speed boost
     0,
    SHIELD = // Damage immunity shield
     1,
    POWER = // Enhanced fire (break steel, 2 bullets)
     2,
    FREEZE = 3 // Freeze all enemies
}
export class PowerUp extends GameEntity {
    powType: PowerUpType;
    timer: number = 0;
    constructor(x: number, y: number, type: PowerUpType) {
        super(x, y, POWERUP_SIZE, POWERUP_SIZE);
        this.powType = type;
        this.layer = RenderLayer.ITEMS;
    }
    update(dt: number): void {
        this.timer++;
        if (this.timer >= POWERUP_LIFETIME) {
            this.isActive = false;
        }
    }
    get shouldBlink(): boolean { return this.timer >= POWERUP_BLINK_START; }
    render(ctx: CanvasRenderingContext2D): void {
        if (this.shouldBlink && Math.floor(this.timer / 30) % 2 === 0)
            return;
        const cx = this.x + this.width / 2;
        const cy = this.y + this.height / 2;
        switch (this.powType) {
            case PowerUpType.SPEED:
                ctx.fillStyle = '#00CC00';
                ctx.fillRect(this.x, this.y, this.width, this.height);
                ctx.fillStyle = '#FFFFFF';
                ctx.font = '20px monospace';
                ctx.fillText('S', cx - 6, cy + 7);
                break;
            case PowerUpType.SHIELD:
                ctx.fillStyle = '#4488FF';
                ctx.fillRect(this.x, this.y, this.width, this.height);
                ctx.fillStyle = '#FFFFFF';
                ctx.font = '20px monospace';
                ctx.fillText('D', cx - 6, cy + 7);
                break;
            case PowerUpType.POWER:
                ctx.fillStyle = '#FF6600';
                ctx.fillRect(this.x, this.y, this.width, this.height);
                ctx.fillStyle = '#FFFFFF';
                ctx.font = '20px monospace';
                ctx.fillText('P', cx - 6, cy + 7);
                break;
            case PowerUpType.FREEZE:
                ctx.fillStyle = '#00CCFF';
                ctx.fillRect(this.x, this.y, this.width, this.height);
                ctx.fillStyle = '#FFFFFF';
                ctx.font = '20px monospace';
                ctx.fillText('F', cx - 6, cy + 7);
                break;
        }
    }
}
