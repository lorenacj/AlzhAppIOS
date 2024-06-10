//
//  PatientMedicineView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 10/6/24.
//

import SwiftUI

struct MedicinesView: View {
    let medicines: [MedicineBO]

    var body: some View {
        List(medicines, id: \.id) { medicine in
            VStack(alignment: .leading) {
                Text(medicine.name ?? "Unknown")
                    .font(.headline)
                Text(medicine.description ?? "No description")
                    .font(.subheadline)
            }
        }
        .navigationBarTitle("Medicinas del Paciente", displayMode: .inline)
    }
}

