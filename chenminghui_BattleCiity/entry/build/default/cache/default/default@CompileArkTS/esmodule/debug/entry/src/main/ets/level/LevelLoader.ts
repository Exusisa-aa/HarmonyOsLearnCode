import { Terrain, charToTileType, TileType } from "@bundle:com.example.battlecity/entry/ets/entity/Terrain";
import { EnemyType } from "@bundle:com.example.battlecity/entry/ets/entity/Tank";
import type { ResourceManager } from '../engine/ResourceManager';
import type { Point, Rect, LevelData } from '../util/Types';
import { TILE_SIZE, MAP_COLS, MAP_ROWS, BASE_X, BASE_Y, BASE_SIZE, PLAYER_START_X, PLAYER_START_Y } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
export interface LevelConfig {
    name: string;
    terrain: Terrain[];
    enemies: EnemyType[];
    totalEnemies: number;
    spawnPoints: Point[];
    baseRect: Rect;
    playerSpawn: Point;
}
export class LevelLoader {
    private resourceMgr: ResourceManager;
    constructor(resourceMgr: ResourceManager) {
        this.resourceMgr = resourceMgr;
    }
    load(levelNum: number): LevelConfig {
        const data: LevelData = this.resourceMgr.loadLevelSync(levelNum);
        return this.parseLevelData(data);
    }
    async loadAsync(levelNum: number): Promise<LevelConfig> {
        const data: LevelData = await this.resourceMgr.loadLevel(levelNum);
        return this.parseLevelData(data);
    }
    private parseLevelData(data: LevelData): LevelConfig {
        const terrainList: Terrain[] = [];
        for (let r = 0; r < data.map.length && r < MAP_ROWS; r++) {
            const row: string = data.map[r];
            for (let c = 0; c < row.length && c < MAP_COLS; c++) {
                const type: TileType = charToTileType(row[c]);
                if (type !== TileType.EMPTY) {
                    terrainList.push(new Terrain(c * TILE_SIZE, r * TILE_SIZE, type));
                }
            }
        }
        // Add base tile
        terrainList.push(new Terrain(BASE_X, BASE_Y, TileType.BASE));
        const enemyList: EnemyType[] = [];
        const basicCount: number = data.enemies.BASIC;
        const fastCount: number = data.enemies.FAST;
        const heavyCount: number = data.enemies.HEAVY;
        for (let i = 0; i < basicCount; i++) {
            enemyList.push(EnemyType.BASIC);
        }
        for (let i = 0; i < fastCount; i++) {
            enemyList.push(EnemyType.FAST);
        }
        for (let i = 0; i < heavyCount; i++) {
            enemyList.push(EnemyType.HEAVY);
        }
        const points: Point[] = [];
        const dataPoints: Point[] = data.spawnPoints;
        if (dataPoints && dataPoints.length > 0) {
            for (const dp of dataPoints) {
                const pt: Point = dp;
                points.push(pt);
            }
        }
        else {
            points.push({ x: 0, y: 0 } as Point);
            points.push({ x: 336, y: 0 } as Point);
            points.push({ x: 672, y: 0 } as Point);
        }
        const baseR: Rect = { x: BASE_X, y: BASE_Y, width: BASE_SIZE, height: BASE_SIZE };
        const playerSpawn: Point = { x: PLAYER_START_X, y: PLAYER_START_Y };
        const config: LevelConfig = {
            name: data.name,
            terrain: terrainList,
            enemies: enemyList,
            totalEnemies: enemyList.length,
            spawnPoints: points,
            baseRect: baseR,
            playerSpawn: playerSpawn
        };
        return config;
    }
}
