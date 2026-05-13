const dragstartHandler = ev => {
  ev.dataTransfer.setData("text", ev.target.id);
}

const dragoverHandler = ev => {
  ev.preventDefault();
}

const dropHandler = ev => {
  ev.preventDefault();
  const data   = ev.dataTransfer.getData("text");
  const target = ev.target.closest('ul');
  if(target) {
    target.appendChild(document.getElementById(data));
    updateSelectMenus();
  }
}

const selectHandler = ev => {
  const targetColumnId = ev.target.value;
  const targetColumn = document.getElementById(targetColumnId);
  const listItem = ev.target.closest('li');
  targetColumn.appendChild(listItem);
  updateSelectMenus();
}


const updateSelectMenus = () => {
  const columns = document.querySelectorAll('.kanban ul');
  const selects = document.querySelectorAll('.kanban li select');

  selects.forEach(select => {
    const parentUl        = select.closest('ul');
    const currentColumnId = parentUl.id;
    select.innerHTML      = '';

    columns.forEach(column => {
      const option       = document.createElement('option');
      option.value       = column.id;
      option.textContent = column.getAttribute('data-identifier');

      if (column.id === currentColumnId) {
        option.selected = true;
      }

      select.appendChild(option);
    });
  });
};
updateSelectMenus();
