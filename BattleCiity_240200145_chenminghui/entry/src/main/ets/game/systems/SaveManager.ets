import { SaveData } from '../data/LevelData';
import { preferences } from '@kit.ArkData';

const STORE_NAME = 'battle_city_save';
const SAVE_KEY = 'game_save';

export class SaveManager {
  private static instance: SaveManager | null = null;

  private constructor() {}

  static getInstance(): SaveManager {
    if (!SaveManager.instance) {
      SaveManager.instance = new SaveManager();
    }
    return SaveManager.instance;
  }

  async saveGame(context: Context, data: SaveData): Promise<boolean> {
    try {
      const json = JSON.stringify(data);
      const prefs = await preferences.getPreferences(context, STORE_NAME);
      await prefs.put(SAVE_KEY, json);
      await prefs.flush();
      return true;
    } catch (_e) {
      return false;
    }
  }

  async loadGame(context: Context): Promise<SaveData | null> {
    try {
      const prefs = await preferences.getPreferences(context, STORE_NAME);
      const json = await prefs.get(SAVE_KEY, '') as string;
      if (!json) {
        return null;
      }
      const data: SaveData = JSON.parse(json);
      return data;
    } catch (_e) {
      return null;
    }
  }

  async hasSaveData(context: Context): Promise<boolean> {
    const data = await this.loadGame(context);
    return data !== null;
  }

  async deleteSave(context: Context): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(context, STORE_NAME);
      await prefs.delete(SAVE_KEY);
      await prefs.flush();
    } catch (_e) {
      // Ignore
    }
  }
}
