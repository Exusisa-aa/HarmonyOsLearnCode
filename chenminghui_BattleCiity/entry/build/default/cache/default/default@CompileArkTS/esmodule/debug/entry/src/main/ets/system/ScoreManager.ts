import preferences from "@ohos:data.preferences";
import { PLAYER_START_LIVES, MAX_LIVES, EXTRA_LIFE_SCORE, SCORE_BASIC_ENEMY, SCORE_FAST_ENEMY, SCORE_HEAVY_ENEMY } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
import { EnemyType } from "@bundle:com.example.battlecity/entry/ets/entity/Tank";
export class ScoreManager {
    score: number = 0;
    lives: number = PLAYER_START_LIVES;
    highScore: number = 0;
    currentLevel: number = 1;
    private lastExtraLifeScore: number = 0;
    private prefs: preferences.Preferences | null = null;
    async init(context: Context): Promise<void> {
        try {
            this.prefs = await preferences.getPreferences(context, 'battle_city_save');
            this.highScore = (await this.prefs.get('highScore', 0)) as number;
        }
        catch (_e) {
            // Preferences unavailable, continue without persistence
        }
    }
    reset(newGame: boolean = true): void {
        if (newGame) {
            this.score = 0;
            this.lives = PLAYER_START_LIVES;
            this.currentLevel = 1;
            this.lastExtraLifeScore = 0;
        }
    }
    addKillScore(enemyType: EnemyType): void {
        if (enemyType === EnemyType.FAST) {
            this.score += SCORE_FAST_ENEMY;
        }
        else if (enemyType === EnemyType.HEAVY) {
            this.score += SCORE_HEAVY_ENEMY;
        }
        else {
            this.score += SCORE_BASIC_ENEMY;
        }
        this.checkExtraLife();
    }
    addLevelClearBonus(bricksRemaining: number): void {
        this.score += bricksRemaining * 50;
        this.checkExtraLife();
    }
    private checkExtraLife(): void {
        if (this.lives < MAX_LIVES && this.score >= this.lastExtraLifeScore + EXTRA_LIFE_SCORE) {
            this.lives++;
            this.lastExtraLifeScore = Math.floor(this.score / EXTRA_LIFE_SCORE) * EXTRA_LIFE_SCORE;
        }
    }
    loseLife(): boolean {
        this.lives--;
        return this.lives <= 0;
    }
    async saveProgress(): Promise<void> {
        if (!this.prefs)
            return;
        try {
            await this.prefs.put('currentLevel', this.currentLevel);
            await this.prefs.put('score', this.score);
            await this.prefs.put('lives', this.lives);
            await this.prefs.flush();
        }
        catch (_e) {
            // Ignore save errors
        }
    }
    async loadProgress(): Promise<boolean> {
        if (!this.prefs)
            return false;
        try {
            const level = (await this.prefs.get('currentLevel', 0)) as number;
            if (level <= 0)
                return false;
            this.currentLevel = level;
            this.score = (await this.prefs.get('score', 0)) as number;
            this.lives = (await this.prefs.get('lives', PLAYER_START_LIVES)) as number;
            this.lastExtraLifeScore = Math.floor(this.score / EXTRA_LIFE_SCORE) * EXTRA_LIFE_SCORE;
            return true;
        }
        catch (_e) {
            return false;
        }
    }
    async clearSave(): Promise<void> {
        if (!this.prefs)
            return;
        try {
            await this.prefs.clear();
            await this.prefs.flush();
        }
        catch (_e) {
            // Ignore clear errors
        }
    }
    async updateHighScore(): Promise<boolean> {
        if (this.score > this.highScore) {
            this.highScore = this.score;
            if (this.prefs) {
                try {
                    await this.prefs.put('highScore', this.highScore);
                    await this.prefs.flush();
                }
                catch (_e) {
                    // Ignore save errors
                }
            }
            return true;
        }
        return false;
    }
}
