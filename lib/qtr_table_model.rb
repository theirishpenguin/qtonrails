class QtrTableModel < Qt::AbstractTableModel

    def initialize(active_record_class, collection, columns=nil)
        super()
        @active_record_class = active_record_class
        @collection = collection

        if columns
            if columns.kind_of? Hash
                @keys = columns.keys
                @labels = columns.values
            else
                @keys = columns
            end
        else
            @keys = []
            @active_record_class.columns.map do |col|
                @keys << col.name unless ['created_at', 'updated_at'].include? col.name
            end
        end

        # Currently need to remember any columns that have an underlying Time type
        # as there is no way to differentiate them from DateTime types for later use
        # and this is important when deciding what time of widget to display

        @time_columns = []
        #enumer = nil
        #if RUBY_VERSION == '1.8.6'
        #    enumber = @active_record_class.columns.enum_for(:each_with_index)
        #else
        #    enumber = @active_record_class.columns.each_with_index
        #end

        #enumber.each{|col, i| @time_columns << i if col.type == :time}

        #require "enumerator"
        #@active_record_class.columns.enum_for(:each_with_index).each{|col, i| @time_columns << i if col.type == :time}

        i = 0
        @active_record_class.columns.each do |col|
            @time_columns << i if col.type == :time
            i += 1
        end

        @labels ||= @keys.collect { |k| k.humanize }
    end

    def rowCount(parent)
        @collection.size
    end

    def columnCount(parent)
        @keys.size
    end

    def data(index, role=Qt::DisplayRole)
        invalid = Qt::Variant.new
        return invalid unless role == Qt::DisplayRole or role == Qt::EditRole

        item = @collection[index.row]
        return invalid if item.nil?

        raise "invalid column #{index.column}" if
            index.column < 0 or index.column > @keys.size

        value = item.attributes[@keys[index.column]]

        # Note: ActiveRecord DateTime attributes lose their DateTime-
        # ness and end up as Times in the QtRuby world. Thus we earlier 
        # remembered the column index of any attributes that may are Times
        # (as opposed to DateTimes). Here, any Time that is known to be a 
        # truly be a Time is left untouched However, if the value is DateTime
        # then we cast it to a DateTime to ensure that both the date and time
        # parts of the attribute is displayed. This means that a Qt::DateTimeEdit
        # widget will be used to display the DateTime values and Qt::TimeEdit widgets
        # will be used to display Time values

        if value.is_a? Time
          value = value.to_datetime unless @time_columns.include? index.column
        end

        return Qt::Variant.new(value)
    end

    def headerData(section, orientation, role=Qt::DisplayRole)
        invalid = Qt::Variant.new
        return invalid unless role == Qt::DisplayRole

        v = case orientation
        when Qt::Horizontal
            @labels[section]
        else
            ""
        end
        return Qt::Variant.new(v)
    end

    def flags(index)
        return Qt::ItemIsEditable | super(index)
    end

    def setData(index, variant, role=Qt::EditRole)
        if index.valid? and role == Qt::EditRole

            item = @collection[index.row]
            values = item.attributes
            att = @keys[index.column]

            index_column_available? index 
            

            values[att] = case item.attributes[att].class.name
            when "String"
                variant.toString
            when "Fixnum"
                variant.toInt
            when "Float"
                variant.toDouble
            # Times in Ruby are really DateTimes as they have a Date
            # aspect to them. Furthermore DateTimes in QtRuby are
            # actually represented as Times. In the data() method
            # above we coerce any Time attributes to be DateTimes
            # so that here it is possible to distinguish them
            when "Time", "DateTime"
                if @time_columns.include? index.column
                    QtrSupport::qt_to_ruby_time(variant.toTime)
                else
                    QtrSupport::qt_to_ruby_date_time(variant.toDateTime)
                end
            when "Date"
                QtrSupport::qt_to_ruby_date(variant.toDate)
            else
                #puts item.attributes[att].class.name
                raise 'Column Type not yet supported'
            end

            item.attributes.each do |attr, old_value|
                item.send("#{attr}=", values[attr])
            end
            item.save
            emit dataChanged(index, index)
            return true
        else
            return false
        end
    end

    private
    def index_column_available?(index)
        raise "invalid column #{index.column}" if
            index.column < 0 or index.column > @keys.size
    end
end

