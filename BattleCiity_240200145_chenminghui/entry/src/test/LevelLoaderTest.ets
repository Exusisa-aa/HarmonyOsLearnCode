import { describe, it, expect } from '@ohos/hypium';
import { LevelLoader } from '../main/ets/game/systems/LevelLoader';
import { generateLevel } from '../main/ets/game/data/LevelGenerator';
import { LevelData } from '../main/ets/game/data/LevelData';
import { TerrainType, TankType } from '../main/ets/common/Constants';

export default function LevelLoaderTest(): void {
  describe('LevelLoader', () => {
    it('load_level_1_data', 0, () => {
      const data = generateLevel(1);
      expect(data.levelNumber).assertEqual(1);
      expect(data.mapRows).assertEqual(26);
      expect(data.mapCols).assertEqual(26);
    });

    it('level_data_has_base', 0, () => {
      const data = generateLevel(1);
      const grid = data.grid;
      // Base should be at (24, 12) area
      const baseFound =
        grid[data.baseY][data.baseX] === TerrainType.BASE;
      expect(baseFound).assertTrue();
    });

    it('level_data_has_clean_player_start', 0, () => {
      const data = generateLevel(1);
      // Player start area should be empty
      expect(
        data.grid[data.playerStartY][data.playerStartX] === TerrainType.EMPTY
      ).assertTrue();
    });

    it('level_data_has_enemies', 0, () => {
      const data = generateLevel(3);
      let totalEnemies = 0;
      for (const config of data.enemies) {
        totalEnemies += config.count;
      }
      expect(totalEnemies > 0).assertTrue();
    });

    it('level_loader_creates_terrain', 0, () => {
      const loader = new LevelLoader();
      const data = generateLevel(2);
      loader.loadLevel(data);
      const terrains = loader.createTerrainEntities();
      // Should have many terrain blocks
      expect(terrains.length > 0).assertTrue();
      // All terrain should be active
      for (const t of terrains) {
        expect(t.active).assertTrue();
      }
    });

    it('level_loader_creates_enemy_queue', 0, () => {
      const loader = new LevelLoader();
      const data = generateLevel(1);
      loader.loadLevel(data);
      const enemies = loader.createEnemyQueue();
      expect(enemies.length > 0).assertTrue();
    });

    it('level_1_to_10_all_generate', 0, () => {
      for (let i = 1; i <= 10; i++) {
        const data = generateLevel(i);
        expect(data.levelNumber).assertEqual(i);
        expect(data.grid.length).assertEqual(26);
        expect(data.grid[0].length).assertEqual(26);
      }
    });

    it('level_data_has_valid_spawn_position', 0, () => {
      const data = generateLevel(1);
      expect(data.enemySpawnX >= 0).assertTrue();
      expect(data.enemySpawnY >= 0).assertTrue();
      expect(data.playerStartX >= 0).assertTrue();
      expect(data.playerStartY >= 0).assertTrue();
    });
  });
}
