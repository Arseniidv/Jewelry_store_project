import SwiftUI
import MapKit

struct ProfileAddressSection: View {
    private let coordinate = CLLocationCoordinate2D(latitude: 13.7239, longitude: 100.5167)
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 13.7239, longitude: 100.5167),
            span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        )
    )

    var body: some View {
        VStack(spacing: 16) {
            addressHeader
            mapView
        }
        .padding(20)
        .appScreenBackground()
    }

    private var addressHeader: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(AppTheme.accentDark)

            VStack(alignment: .leading, spacing: 4) {
                Text("Gems Tower, 1249 ถ. เจริญกรุง")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Text("Suriya Wong, Bang Rak, Bangkok 10500, Таиланд")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()
        }
        .padding(16)
        .background(AppTheme.surfaceMuted)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var mapView: some View {
        GeometryReader { geometry in
            Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
                Marker("Gems Tower", systemImage: "building.2.fill", coordinate: coordinate)
                    .tint(.red)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.surfaceMuted, lineWidth: 1)
            )
        }
    }
}
