// Generic object pool for performance optimization (task 12.5)
// Reuses game objects to avoid garbage collection pressure

export class ObjectPool<T> {
  private pool: T[] = [];
  private active: Set<T> = new Set();
  private factory: () => T;
  private resetFn: (item: T) => void;
  private initialSize: number;

  constructor(
    factory: () => T,
    resetFn: (item: T) => void,
    initialSize: number = 20
  ) {
    this.factory = factory;
    this.resetFn = resetFn;
    this.initialSize = initialSize;
    this.preAllocate();
  }

  private preAllocate(): void {
    for (let i = 0; i < this.initialSize; i++) {
      const item = this.factory();
      this.resetFn(item);
      this.pool.push(item);
    }
  }

  acquire(): T {
    let item: T;
    if (this.pool.length > 0) {
      item = this.pool.pop()!;
    } else {
      item = this.factory();
    }
    this.active.add(item);
    return item;
  }

  release(item: T): void {
    if (this.active.has(item)) {
      this.active.delete(item);
      this.resetFn(item);
      this.pool.push(item);
    }
  }

  releaseAll(): void {
    for (const item of this.active) {
      this.resetFn(item);
      this.pool.push(item);
    }
    this.active.clear();
  }

  getActiveCount(): number {
    return this.active.size;
  }

  getPoolSize(): number {
    return this.pool.length;
  }
}
