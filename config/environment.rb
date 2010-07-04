QTRAILS_ENV = 'development'

# Comment this QtrTableModel section if you want your index pages to have
# grids that are editable in-place
class QtrTableModel
  def flags(index)
    return Qt::ItemIsSelectable | super(index)
  end
end