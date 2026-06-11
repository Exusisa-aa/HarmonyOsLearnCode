import { LevelData } from '../data/LevelData';
import { generateLevel } from '../data/LevelGenerator';

export class ResourceManager {
  private static instance: ResourceManager | null = null;

  private levels: Map<number, LevelData> = new Map();
  private images: Map<string, ImageBitmap> = new Map();
  private loaded: boolean = false;

  private constructor() {}

  static getInstance(): ResourceManager {
    if (!ResourceManager.instance) {
      ResourceManager.instance = new ResourceManager();
    }
    return ResourceManager.instance;
  }

  static resetInstance(): void {
    ResourceManager.instance = null;
  }

  isLoaded(): boolean {
    return this.loaded;
  }

  async preloadAll(): Promise<void> {
    // Generate all 10 levels procedurally
    for (let i = 1; i <= 10; i++) {
      const levelData = generateLevel(i);
      this.levels.set(i, levelData);
    }
    this.loaded = true;
  }

  getLevel(levelNum: number): LevelData | undefined {
    return this.levels.get(levelNum);
  }

  getTotalLevels(): number {
    return this.levels.size;
  }

  getImage(key: string): ImageBitmap | undefined {
    return this.images.get(key);
  }

  releaseResources(): void {
    this.levels.clear();
    this.images.clear();
    this.loaded = false;
  }
}
