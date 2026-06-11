import { PlayerTank } from '../entities/PlayerTank';
import { InputManager, InputCommand } from './InputManager';
import { GameStateManager } from '../core/GameStateManager';
import { GameState } from '../../common/Constants';

export class PlayerController {
  private inputManager: InputManager;
  private stateManager: GameStateManager;

  constructor(inputManager: InputManager) {
    this.inputManager = inputManager;
    this.stateManager = GameStateManager.getInstance();
  }

  updatePlayer(player: PlayerTank, deltaMs: number): void {
    if (!player.active || !this.stateManager.isRunning()) {
      return;
    }

    player.updatePowerUpTimers(deltaMs);
    player.updateCooldown(deltaMs);

    const input = this.inputManager.getInputCommand();
    this.applyMovement(player, input);
    this.applyShooting(player, input);
  }

  private applyMovement(player: PlayerTank, input: InputCommand): void {
    if (!input.wantsMove) {
      return;
    }

    player.direction = input.direction;
    const speed = player.getEffectiveSpeed();
    const dx = player.getDirectionDX() * speed;
    const dy = player.getDirectionDY() * speed;
    player.move(dx, dy);

    // Boundary clamping done in collision system
  }

  private applyShooting(player: PlayerTank, input: InputCommand): void {
    // Note: actual bullet creation is done in GameWorld since it needs
    // access to the bullet pool. Here we just track the shoot request.
    // The shoot request is passed through the input command's wantsShoot.
  }

  wantsToShoot(): boolean {
    return this.inputManager.getInputCommand().wantsShoot;
  }

  endFrame(): void {
    this.inputManager.endFrame();
  }
}
