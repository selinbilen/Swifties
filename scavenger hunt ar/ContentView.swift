import SwiftUI

struct Room: Identifiable {
    let id = UUID() // id for every room instance
    let participants: [String]
    let startTime: Date // date-time the game started
    let participantGameplays: [ParticipantGameplay] // list of gameplays
}

struct ParticipantGameplay: Identifiable {
    let id = UUID() // id for every ParticipantGameplay instance
    let participantId: String // id of Participant
    var checkpointTime: Date // date-time the player found an object
    var score: Int = 0 // numerical score
}

// Helpful video for working with date objects https://www.youtube.com/watch?v=Le8VmQyZWYw

struct LeaderboardView: View {
    @Binding var RoomObj: Room
    
    var body: some View {
        VStack {
            Text("Leaderboard for Room \(RoomObj.id.uuidString)")
        }
        .navigationTitle("Leaderboard View")
    }
}

let exampleParticipantGameplays = [
    ParticipantGameplay(participantId: "1001", checkpointTime: Date().addingTimeInterval(42)),
    ParticipantGameplay(participantId: "1001", checkpointTime: Date().addingTimeInterval(131)),
    ParticipantGameplay(participantId: "1001", checkpointTime: Date().addingTimeInterval(34)),
    ParticipantGameplay(participantId: "1001", checkpointTime: Date().addingTimeInterval(256)),
]

struct ContentView: View {
    @State var RoomObj = Room(participants: [], startTime: Date(), participantGameplays: exampleParticipantGameplays)
    
    var body: some View {
        NavigationView(content: {
            NavigationLink(destination: LeaderboardView(RoomObj: $RoomObj)) {
                Text("Navigate to Leaderboard")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
