import {Component, Event, EventEmitter, h, Prop} from '@stencil/core';

@Component({
  tag: 'c-pagination',
  styleUrl: 'pagination.scss',
  shadow: false,
})
export class Pagination {
  @Prop() currentPage: number = 1;
  @Prop() totalPages: number = 1;

  @Event() pageChange: EventEmitter<number>;

  handlePageChange(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.pageChange.emit(page);
    }
  }

  render() {
    return (
      <div class="pagination">
        <button onClick={() => this.handlePageChange(this.currentPage - 1)} disabled={this.currentPage === 1}>
          Previous
        </button>
        {Array.from({length: this.totalPages}, (_, i) => i + 1).map(page => (
          <button
            onClick={() => this.handlePageChange(page)}
            class={this.currentPage === page ? 'active' : ''}
          >
            {page}
          </button>
        ))}
        <button onClick={() => this.handlePageChange(this.currentPage + 1)}
                disabled={this.currentPage === this.totalPages}>
          Next
        </button>
      </div>
    );
  }
}
