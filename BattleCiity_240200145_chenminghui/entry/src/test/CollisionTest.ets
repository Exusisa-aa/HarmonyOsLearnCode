import { describe, it, expect } from '@ohos/hypium';
import { CollisionSystem } from '../main/ets/game/systems/CollisionSystem';
import { AABB, BaseEntity } from '../main/ets/game/entities/BaseEntity';
import { EntityType } from '../main/ets/common/Constants';

// Minimal concrete entity for testing
class TestEntity extends BaseEntity {
  constructor(x: number, y: number, w: number, h: number) {
    super(EntityType.TERRAIN);
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
  }
}

export default function CollisionTest(): void {
  describe('CollisionSystem', () => {
    it('AABB_should_detect_overlap', 0, () => {
      const a = new AABB(0, 0, 10, 10);
      const b = new AABB(5, 5, 10, 10);
      expect(CollisionSystem.checkAABB(a, b)).assertTrue();
    });

    it('AABB_should_reject_separated', 0, () => {
      const a = new AABB(0, 0, 10, 10);
      const b = new AABB(20, 20, 10, 10);
      expect(CollisionSystem.checkAABB(a, b)).assertFalse();
    });

    it('AABB_edge_touching_not_overlapping', 0, () => {
      const a = new AABB(0, 0, 10, 10);
      const b = new AABB(10, 0, 10, 10);
      // Touching at edge should NOT overlap
      expect(CollisionSystem.checkAABB(a, b)).assertFalse();
    });

    it('AABB_one_inside_another', 0, () => {
      const a = new AABB(0, 0, 20, 20);
      const b = new AABB(5, 5, 5, 5);
      expect(CollisionSystem.checkAABB(a, b)).assertTrue();
    });

    it('bounds_check_inside', 0, () => {
      expect(CollisionSystem.checkBounds(5, 5, 10, 10, 100, 100)).assertTrue();
    });

    it('bounds_check_outside_right', 0, () => {
      expect(CollisionSystem.checkBounds(95, 5, 10, 10, 100, 100)).assertFalse();
    });

    it('bounds_check_outside_bottom', 0, () => {
      expect(CollisionSystem.checkBounds(5, 95, 10, 10, 100, 100)).assertFalse();
    });

    it('entity_collision_detection', 0, () => {
      const e1 = new TestEntity(0, 0, 16, 16);
      const e2 = new TestEntity(8, 8, 16, 16);
      expect(e1.collidesWith(e2)).assertTrue();
    });

    it('entity_no_collision', 0, () => {
      const e1 = new TestEntity(0, 0, 16, 16);
      const e2 = new TestEntity(50, 50, 16, 16);
      expect(e1.collidesWith(e2)).assertFalse();
    });

    it('bullet_tank_collision_scenario', 0, () => {
      // Tank at (32, 32) size 16x16
      // Bullet at (40, 40) size 4x4
      const tank = new TestEntity(32, 32, 16, 16);
      const bullet = new TestEntity(40, 40, 4, 4);
      expect(bullet.collidesWith(tank)).assertTrue();
    });
  });
}
