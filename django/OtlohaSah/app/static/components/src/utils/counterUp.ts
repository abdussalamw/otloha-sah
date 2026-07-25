export function counterUp(
  startValue: number,
  endValue: number,
  duration: number,
  updateCallback: (value: number) => void
) {
  let startTime: number | null = null;

  function animate(time: number) {
    if (!startTime) startTime = time;
    const elapsed = time - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const currentValue = Math.floor(startValue + (endValue - startValue) * progress);
    updateCallback(currentValue);

    if (progress < 1) {
      requestAnimationFrame(animate);
    }
  }

  requestAnimationFrame(animate);
}
