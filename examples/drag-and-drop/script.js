const dragstartHandler = ev => {
  ev.dataTransfer.setData('text', ev.target.id);
}

const dragoverHandler = ev => {
  ev.preventDefault();
}

const dropHandler = ev => {
  ev.preventDefault();
  const data   = ev.dataTransfer.getData('text');
  const target = ev.target.closest('ol');
  if(target) {
    target.appendChild(document.getElementById(data));
    updateSelectMenus();
  }
}

const selectHandler = ev => {
  const targetColumnId = ev.target.value;
  const listItem       = ev.target.closest('li');
  const targetColumn   = document.getElementById(targetColumnId);
  targetColumn.appendChild(listItem);
  updateSelectMenus();
}


const updateSelectMenus = () => {
  const columns = document.querySelectorAll('.kanban ol');
  const selects = document.querySelectorAll('.kanban li select');

  selects.forEach(select => {
    const parentUl        = select.closest('ol');
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

    select.removeEventListener('change', selectHandler);
    select.addEventListener('change', selectHandler);
  });
};

const initBoardEvents = () => {
  const allOLs = document.querySelectorAll('.kanban ol');
  allOLs.forEach(ol => {
    ol.addEventListener('drop', dropHandler);
    ol.addEventListener('dragover', dragoverHandler);
  });

  const allLIs = document.querySelectorAll('.kanban li');
  allLIs.forEach(li => {
    li.addEventListener('dragstart', dragstartHandler);
  });
};

updateSelectMenus();
initBoardEvents();
