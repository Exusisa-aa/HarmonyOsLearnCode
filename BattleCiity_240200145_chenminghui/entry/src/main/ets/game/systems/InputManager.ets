import { Direction } from '../../common/Constants';
import { JoystickEvent } from '../../ui/VirtualJoystick';

export interface InputCommand {
  direction: Direction;
  wantsMove: boolean;
  wantsShoot: boolean;
}

export class InputManager {
  private joystickActive: boolean = false;
  private joystickDx: number = 0;
  private joystickDy: number = 0;
  private shootPressed: boolean = false;
  private prevShootPressed: boolean = false;

  setJoystickEvent(event: JoystickEvent): void {
    this.joystickActive = event.active;
    this.joystickDx = event.dx;
    this.joystickDy = event.dy;
  }

  setShootPressed(pressed: boolean): void {
    this.prevShootPressed = this.shootPressed;
    this.shootPressed = pressed;
  }

  // Returns true on the frame shoot button is first pressed
  isShootTriggered(): boolean {
    return this.shootPressed && !this.prevShootPressed;
  }

  getDirection(): Direction {
    if (!this.joystickActive) {
      return Direction.UP; // default, won't be used since wantsMove = false
    }

    const dx = this.joystickDx;
    const dy = this.joystickDy;

    if (Math.abs(dx) > Math.abs(dy)) {
      return dx > 0 ? Direction.RIGHT : Direction.LEFT;
    } else {
      return dy > 0 ? Direction.DOWN : Direction.UP;
    }
  }

  getInputCommand(): InputCommand {
    const wantsMove = this.joystickActive &&
      (Math.abs(this.joystickDx) > 0.2 || Math.abs(this.joystickDy) > 0.2);

    return {
      direction: this.getDirection(),
      wantsMove: wantsMove,
      wantsShoot: this.isShootTriggered(),
    };
  }

  // Call at end of frame to clear edge-triggered states
  endFrame(): void {
    this.prevShootPressed = this.shootPressed;
  }
}
