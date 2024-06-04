//
//  SharedCalendar.swift
//  AlzhApp
//
//  Created by lorena.cruz on 4/6/24.
//

import SwiftUI
#warning("message: Falta poner API y lista de eventos / marcados")

struct Day: Identifiable {
    let id = UUID()
    let date: Date
    var annotation: String = ""
}

struct SharedCalendar: View {
    @State private var selectedDate: Date?
    @State private var days: [Day] = generateDaysForCurrentMonth()
    @State private var showingAnnotationInput = false
    @State private var annotationText = ""
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(days) { day in
                        Button(action: {
                            selectedDate = day.date
                            annotationText = day.annotation
                            showingAnnotationInput = true
                        }) {
                            VStack {
                                Text(dayOfMonthFormatter.string(from: day.date))
                                    .font(.headline)
                                if !day.annotation.isEmpty {
                                    Text(day.annotation)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: proxy.size.width / 9, height: proxy.size.width / 9)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
            .sheet(isPresented: $showingAnnotationInput) {
                VStack {
                    Text("Add Annotation")
                        .font(.headline)
                    TextField("Annotation", text: $annotationText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Save") {
                        if let date = selectedDate,
                           let index = days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                            days[index].annotation = annotationText
                        }
                        showingAnnotationInput = false
                    }
                    .padding()
                }
                .padding()
            }
        }
        .onTapGesture {
            endEditing()
        }
    }
}

private func generateDaysForCurrentMonth() -> [Day] {
    var days: [Day] = []
    let calendar = Calendar.current
    let date = Date()
    let range = calendar.range(of: .day, in: .month, for: date)!
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    
    for day in range {
        if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
            days.append(Day(date: date))
        }
    }
    return days
}

private let dayOfMonthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}()


#Preview {
    SharedCalendar()
}
