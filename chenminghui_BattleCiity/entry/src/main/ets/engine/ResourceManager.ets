import { resourceManager } from '@kit.LocalizationKit';
import { util } from '@kit.ArkTS';
import { LevelData, LevelDataEnemies, Point } from '../util/Types';

export class ResourceManager {
  private rawfile: resourceManager.ResourceManager | null = null;

  init(context: Context): void {
    this.rawfile = context.resourceManager;
  }

  async loadLevel(levelNum: number): Promise<LevelData> {
    const fileName: string = 'levels/level_' + levelNum.toString().padStart(2, '0') + '.json';
    try {
      const rawData: Uint8Array = await this.rawfile!.getRawFileContent(fileName);
      const textDecoder = new util.TextDecoder('utf-8');
      const text: string = textDecoder.decodeToString(rawData);
      return JSON.parse(text) as LevelData;
    } catch (_e) {
      return this.defaultLevel(levelNum);
    }
  }

  loadLevelSync(levelNum: number): LevelData {
    return this.defaultLevel(levelNum);
  }

  private defaultLevel(levelNum: number): LevelData {
    const mapData: string[] = [
      "...............",
      "...............",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#@#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.....#.#..",
      "..###########..",
      "..#.#.....#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "..#.#.#.#.#.#..",
      "...............",
      ".....&...&.....",
      ".....&...&.....",
      "..............."
    ];
    const enemies: LevelDataEnemies = { BASIC: 10, FAST: 0, HEAVY: 0 };
    const spawnPoints: Point[] = [
      { x: 0, y: 0 } as Point,
      { x: 336, y: 0 } as Point,
      { x: 672, y: 0 } as Point
    ];
    const result: LevelData = {
      name: 'STAGE ' + levelNum.toString(),
      map: mapData,
      enemies: enemies,
      spawnPoints: spawnPoints
    };
    return result;
  }
}
