import SwiftUI

struct Calender: View {
    
    @State var sheetPresented = false
    

    var day1 = Calendar(identifier: .gregorian).startOfDay(for: Date())
    var day2 = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: Date())

    

    
    var clManagerX = CLManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*365), maximumDate: Date())
    

    var body: some View {
        VStack (spacing: 15) {

            Button(action: { self.sheetPresented.toggle() }) {
                Text("カレンダー")
            }
            .sheet(isPresented: self.$sheetPresented, content: {
                CLViewController(isPresented: self.$sheetPresented, clManager: self.clManagerX)})
        }
    }

}

struct Callender_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Calender()
        }
    }
}

struct CLCell: View {

    var clDate: CLDate
    var cellWidth: CGFloat

    var body: some View {
        
        Text(clDate.getText())
        .fontWeight(clDate.getFontWeight())
        .foregroundColor(clDate.getColor())
        .frame(width: 25, height: 25)
        .font(.system(size: 16))
        .cornerRadius(cellWidth/2)
        
    }
}

struct CLDate {

    var date: Date
    let clManager: CLManager

    var isToday: Bool = false
    var isSelected: Bool = false

    init(date: Date, clManager: CLManager, isToday: Bool, isSelected: Bool) {

        self.date = date
        self.clManager = clManager
        self.isToday = isToday
        self.isSelected = isSelected
    }

    func getText() -> String {
        let day = formatDate(date: date, calendar: self.clManager.calendar)
        return day
    }


    func getFontWeight() -> Font.Weight {
        var fontWeight = Font.Weight.thin

        if isSelected {
            fontWeight = Font.Weight.heavy
        } else if isToday {
            fontWeight = Font.Weight.heavy
        }
            return fontWeight
    }

    func getColor() -> Color? {
        var col = Color.black

        if isSelected {
            col = Color.red
        } else if isToday {
            col = Color.orange
        } else if date < Date() {
            col = Color.black
        } else if date > Date() {
            col = Color.gray
        }
        
        return col

    }

    func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }

    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }

    func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}

struct CLViewController: View {

    @Binding var isPresented: Bool
    @ObservedObject var clManager: CLManager
    
    var clManagerX = CLManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*365), maximumDate: Date())

    var body: some View {
        Group {
            List {
                ForEach((0...numberOfMonths() - 1).reversed(), id: \.self) { index in
                CLMonth(isPresented: self.$isPresented, clManager: self.clManager, monthOffset: index)
                }
                Divider()
            }
        }
    }

    func numberOfMonths() -> Int {
        return clManager.calendar.dateComponents([.month], from: clManager.minimumDate, to: CLMaximumDateMonthLastDay()).month! + 1
    }

    func CLMaximumDateMonthLastDay() -> Date {
        var components = clManager.calendar.dateComponents([.year, .month, .day], from: clManager.maximumDate)
        components.month! += 1
        components.day = 0
        return clManager.calendar.date(from: components)!
    }
}

class CLManager : ObservableObject {

    @Published var calendar = Calendar.current
    @Published var minimumDate: Date = Date()
    @Published var maximumDate: Date = Date()
    @Published var selectedDates: [Date] = [Date]()
    @Published var selectedDate: Date! = nil



    init(calendar: Calendar, minimumDate: Date, maximumDate: Date, selectedDates: [Date] = [Date]()) {
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.selectedDates = selectedDates
    }

    func selectedDatesContains(date: Date) -> Bool {
        if let _ = self.selectedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }


    func selectedDatesFindIndex(date: Date) -> Int? {
        return self.selectedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }

}


struct CLMonth: View {

    @Binding var isPresented: Bool
    
    @ObservedObject var clManager: CLManager

    let monthOffset: Int
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
    var monthsArray: [[Date]] {
    monthArray()
    }
    let cellWidth = CGFloat(25)

    @State var showTime = false
    @State var searchList = false

    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 10){
            Text(getMonthHeader())
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(monthsArray, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(row, id: \.self) { column in
                            HStack() {
                                Spacer()
                                if self.isThisMonth(date: column) {
                                    CLCell(clDate: CLDate(
                                    date: column,
                                    clManager: self.clManager,
                                    isToday: self.isToday(date: column),
                                    isSelected: self.isSpecialDate(date: column)
                                    ),                            cellWidth: self.cellWidth)
                                    .onTapGesture {
                                        self.dateTapped(date: column)
                                        self.searchList = true
                                    }
                                } else {
                                    Text("").frame(width: 25, height: 25)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $searchList, content: {
            PostsSortedByDate(selectedDate: clManager.selectedDate)
        })
    }

    func isThisMonth(date: Date) -> Bool {
        return self.clManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
    }

    func dateTapped(date: Date) {
        if self.clManager.selectedDate != nil &&
            self.clManager.calendar.isDate(self.clManager.selectedDate, inSameDayAs: date) {
            self.clManager.selectedDate = nil

        } else {
            self.clManager.selectedDate = date
        }
        //self.isPresented = false
    }

    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            
            for column in 0 ... 6 {
                let abc = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }

    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = clManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy LLLL", options: 0, locale: clManager.calendar.locale)

        return headerDateFormatter.string(from: firstOfMonthForOffset()).uppercased()
    }

    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = clManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - clManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset

        return clManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }

    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = clManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)

        return (rangeOfWeeks?.count)! * daysPerWeek
    }

    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset

        return clManager.calendar.date(byAdding: offset, to: CLFirstDateMonth())!
    }

    func CLFormatDate(date: Date) -> Date {
        let components = clManager.calendar.dateComponents(calendarUnitYMD, from: date)

        return clManager.calendar.date(from: components)!
    }

    func CLFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = CLFormatDate(date: referenceDate)
        let clampedDate = CLFormatDate(date: date)
        return refDate == clampedDate
    }

    func CLFirstDateMonth() -> Date {
        var components = clManager.calendar.dateComponents(calendarUnitYMD, from: clManager.minimumDate)
        components.day = 1

        return clManager.calendar.date(from: components)!
    }


    func isToday(date: Date) -> Bool {
        return CLFormatAndCompareDate(date: date, referenceDate: Date())
    }

    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date)
    }



    func isSelectedDate(date: Date) -> Bool {
        if clManager.selectedDate == nil {
            return false
        }
        return CLFormatAndCompareDate(date: date, referenceDate: clManager.selectedDate)
    }

}
