export interface Segment {
  count: number;
  name: string;
  color: string;
}

export interface ChartData {
  count: any;
  label: string;
  component: any;
  segments: Segment[];
}
