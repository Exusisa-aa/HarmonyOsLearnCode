export interface JoystickEvent {
  dx: number; // -1 to 1 horizontal
  dy: number; // -1 to 1 vertical
  active: boolean;
}

@Component
export struct VirtualJoystick {
  @Link joystickEvent: JoystickEvent;
  private baseRadius: number = 60;
  private thumbRadius: number = 25;
  private deadZone: number = 10;
  private touchId: number = -1;

  @State private thumbX: number = 0;
  @State private thumbY: number = 0;

  build() {
    Stack() {
      // Base circle
      Circle({ width: this.baseRadius * 2, height: this.baseRadius * 2 })
        .fill('#33333355')
        .stroke('#FFFFFF66')
        .strokeWidth(2)

      // Thumb circle
      Circle({ width: this.thumbRadius * 2, height: this.thumbRadius * 2 })
        .fill('#FFFFFF44')
        .stroke('#FFFFFF88')
        .strokeWidth(1)
        .offset({ x: this.thumbX, y: this.thumbY })
    }
    .width(this.baseRadius * 2)
    .height(this.baseRadius * 2)
    .onTouch((event: TouchEvent) => {
      this.handleTouch(event);
    })
  }

  private handleTouch(event: TouchEvent): void {
    switch (event.type) {
      case TouchType.Down: {
        if (event.touches.length > 0) {
          this.touchId = 0;
          const touch = event.touches[0];
          this.processTouch(touch.x, touch.y);
        }
        break;
      }
      case TouchType.Move: {
        for (let i = 0; i < event.touches.length; i++) {
          if (i === this.touchId || this.touchId < 0) {
            const touch = event.touches[i];
            this.processTouch(touch.x, touch.y);
            if (this.touchId < 0) this.touchId = i;
            break;
          }
        }
        break;
      }
      case TouchType.Up:
      case TouchType.Cancel: {
        this.touchId = -1;
        this.thumbX = 0;
        this.thumbY = 0;
        this.joystickEvent = { dx: 0, dy: 0, active: false };
        break;
      }
    }
  }

  private processTouch(localX: number, localY: number): void {
    // Convert relative to center
    const cx = localX - this.baseRadius;
    const cy = localY - this.baseRadius;

    const dist = Math.sqrt(cx * cx + cy * cy);
    if (dist < this.deadZone) {
      this.thumbX = cx;
      this.thumbY = cy;
      this.joystickEvent = { dx: 0, dy: 0, active: false };
      return;
    }

    // Clamp to base radius
    const clampDist = Math.min(dist, this.baseRadius - this.thumbRadius);
    const nx = cx / dist;
    const ny = cy / dist;

    this.thumbX = nx * clampDist;
    this.thumbY = ny * clampDist;
    this.joystickEvent = {
      dx: nx,
      dy: ny,
      active: true,
    };
  }
}
