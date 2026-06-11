import { describe, it, expect } from '@ohos/hypium';
import { GameStateManager } from '../main/ets/game/core/GameStateManager';
import { GameState } from '../main/ets/common/Constants';

export default function StateMachineTest(): void {
  describe('GameStateManager', () => {
    it('initial_state_is_INIT', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      expect(sm.getState()).assertEqual(GameState.INIT);
    });

    it('valid_transition_INIT_to_RUNNING', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      sm.setState(GameState.RUNNING);
      expect(sm.getState()).assertEqual(GameState.RUNNING);
    });

    it('valid_transition_RUNNING_to_PAUSED', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      sm.setState(GameState.RUNNING);
      sm.setState(GameState.PAUSED);
      expect(sm.isPaused()).assertTrue();
    });

    it('valid_transition_PAUSED_to_RUNNING', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      sm.setState(GameState.RUNNING);
      sm.setState(GameState.PAUSED);
      sm.setState(GameState.RUNNING);
      expect(sm.isRunning()).assertTrue();
    });

    it('valid_transition_to_GAME_OVER', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      sm.setState(GameState.RUNNING);
      sm.setState(GameState.GAME_OVER);
      expect(sm.isGameOver()).assertTrue();
    });

    it('state_change_callback_fired', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      let fired = false;
      let fromState = GameState.INIT;
      let toState = GameState.INIT;

      sm.onStateChange((from: GameState, to: GameState) => {
        fired = true;
        fromState = from;
        toState = to;
      });

      sm.setState(GameState.RUNNING);
      expect(fired).assertTrue();
      expect(fromState).assertEqual(GameState.INIT);
      expect(toState).assertEqual(GameState.RUNNING);
    });

    it('same_state_no_callback', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      let count = 0;
      sm.onStateChange(() => { count++; });

      sm.setState(GameState.INIT); // Same as current
      expect(count).assertEqual(0);
    });

    it('previous_state_tracked', 0, () => {
      GameStateManager.resetInstance();
      const sm = GameStateManager.getInstance();
      sm.setState(GameState.RUNNING);
      sm.setState(GameState.PAUSED);
      expect(sm.getPreviousState()).assertEqual(GameState.RUNNING);
    });
  });
}
