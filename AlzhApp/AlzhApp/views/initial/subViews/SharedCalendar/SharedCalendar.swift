//  SharedCalendar.swift
//  AlzhApp
//
//  Created by lorena.cruz on 4/6/24.
//

import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var date: Date
    var annotation: String
}

struct SharedCalendar: View {
    @State private var events: [Event] = generateSampleEvents()
    @State private var selectedEvent: Event?
    @State private var annotationText: String = ""
    @State private var showingAnnotationInput: Bool = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(events) { event in
                        Button(action: {
                            selectedEvent = event
                            annotationText = event.annotation
                            showingAnnotationInput = true
                        }) {
                            VStack(alignment: .leading) {
                                Text(eventFormatter.string(from: event.date))
                                    .font(.headline)
                                if !event.annotation.isEmpty {
                                    Text(event.annotation)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                        if let event = selectedEvent,
                           let index = events.firstIndex(where: { $0.id == event.id }) {
                            events[index].annotation = annotationText
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

private func generateSampleEvents() -> [Event] {
    // Generate some sample events for demonstration
    let calendar = Calendar.current
    var events: [Event] = []
    let currentDate = Date()
    for i in 0..<10 {
        if let date = calendar.date(byAdding: .day, value: i, to: currentDate) {
            events.append(Event(date: date, annotation: ""))
        }
    }
    return events
}

private let eventFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    SharedCalendar()
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
