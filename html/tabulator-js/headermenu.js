// add helper columns that should be excluded from the header menu
excludeFromHeaderMenu = ["itemid"];
// Define column header menu as column visibility toggle
const headerMenu = function () {
  let menu = [];
  const allColumns = this.getColumns();

  allColumns.forEach((column) => {
    const field = column.getField();
    // Skip rowHeaders and columns that are excluded from the header menu
    if (!field || excludeFromHeaderMenu.includes(field)) {
      return;
    }

    let icon = document.createElement("i");
    icon.className = "bi " + (column.isVisible() ? "bi-eye" : "bi-eye-slash");
    table = this
    //build label (contains icon and title)
    let label = document.createElement("span");
    let title = document.createElement("span");

    title.innerHTML = " " + column.getDefinition().title;

    label.appendChild(icon);
    label.appendChild(title);
    // Take inital visibility into account
    if (!column.isVisible()) {
      label.classList.add("text-muted");
    }

    //create menu item
    menu.push({
      label: label,
      action: function (e) {
        // Prevent menu closing
        e.stopPropagation();

        // Toggle current column visibility
        column.toggle();

        // Clear the header filter if column is now hidden
        if (!column.isVisible()) {
          table.setHeaderFilterValue(column.getField(), null);
        }

        // Redraw the table, potentially uncollapsing columns
        table.redraw();

        // Change menu item icon and toggle text-muted class based on visibility
        label.classList.toggle("text-muted", !column.isVisible());
        icon.className =
          "bi " + (column.isVisible() ? "bi-eye" : "bi-eye-slash");
      },
    });
  });

  return menu;
};