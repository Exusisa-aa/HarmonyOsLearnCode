import { describe, it, expect } from '@ohos/hypium';
import { SaveData } from '../main/ets/game/data/LevelData';

export default function SaveManagerTest(): void {
  describe('SaveManager', () => {
    it('save_data_serialization_roundtrip', 0, () => {
      const saveData: SaveData = {
        version: 1,
        currentLevel: 3,
        score: 12500,
        lives: 2,
        terrainState: [
          [true, false, true],
          [false, true, false],
        ],
        timestamp: Date.now(),
      };

      const json = JSON.stringify(saveData);
      const parsed: SaveData = JSON.parse(json);

      expect(parsed.version).assertEqual(1);
      expect(parsed.currentLevel).assertEqual(3);
      expect(parsed.score).assertEqual(12500);
      expect(parsed.lives).assertEqual(2);
      expect(parsed.terrainState[0][0]).assertTrue();
      expect(parsed.terrainState[0][1]).assertFalse();
    });

    it('save_data_empty_terrain_state', 0, () => {
      const saveData: SaveData = {
        version: 1,
        currentLevel: 1,
        score: 0,
        lives: 3,
        terrainState: [],
        timestamp: 0,
      };

      const json = JSON.stringify(saveData);
      const parsed: SaveData = JSON.parse(json);
      expect(parsed.lives).assertEqual(3);
      expect(parsed.terrainState.length).assertEqual(0);
    });

    it('save_data_max_score', 0, () => {
      const saveData: SaveData = {
        version: 1,
        currentLevel: 10,
        score: 999999,
        lives: 5,
        terrainState: [],
        timestamp: Date.now(),
      };

      const json = JSON.stringify(saveData);
      const parsed: SaveData = JSON.parse(json);
      expect(parsed.score).assertEqual(999999);
      expect(parsed.currentLevel).assertEqual(10);
    });

    it('save_data_version_check', 0, () => {
      const data: SaveData = {
        version: 2,
        currentLevel: 1,
        score: 100,
        lives: 2,
        terrainState: [],
        timestamp: 0,
      };

      expect(data.version).assertEqual(2);
    });

    it('save_data_integrity_after_json', 0, () => {
      const original: SaveData = {
        version: 1,
        currentLevel: 5,
        score: 50000,
        lives: 4,
        terrainState: [
          [true, true, true],
          [false, false, false],
        ],
        timestamp: 1715000000000,
      };

      const json = JSON.stringify(original);
      const restored = JSON.parse(json) as SaveData;

      // All fields must match
      expect(restored.version === original.version).assertTrue();
      expect(restored.currentLevel === original.currentLevel).assertTrue();
      expect(restored.score === original.score).assertTrue();
      expect(restored.lives === original.lives).assertTrue();
      expect(restored.timestamp === original.timestamp).assertTrue();
      expect(restored.terrainState.length === original.terrainState.length).assertTrue();
    });
  });
}
