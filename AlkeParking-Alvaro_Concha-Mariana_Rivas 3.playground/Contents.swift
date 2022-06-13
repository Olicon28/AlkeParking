import UIKit
import Foundation


extension Date {
    static func createDate(hour: Int, mins: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = mins
        let userCalendar = Calendar(identifier: .gregorian)
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime ?? Date()
    }
}


//MARK: Enums and Protocols
enum VehicleType{
    case car
    case moto
    case miniBus
    case bus
    
    var rate : Int {
        switch self {
            case .car :
                return 20
            case .moto :
                return 15
            case .miniBus :
                return 25
            case .bus :
                return 30
        }
    }
}

protocol Parkable {
    var plate: String { get }
    var type : VehicleType { get }
    var checkInTime : Date { get }
    var checkOutTime : Date? { get }
    var discountCard : String? { get }
    var parkedTime : Int { get }
    
}


//MARK: Parking Struct
struct Parking {
    var vehicles: Set<Vehicle> = []
    let limit : Int = 20
    var totalFee : Int = 0
    var totalVehicles : Int = 0


    mutating func checkInVehicle(vehicle : Vehicle, onFinish : (Bool) -> Void) -> Void{
        guard vehicles.count <= limit-1 else {
            onFinish(false);
            return
        }
        guard !vehicles.contains(vehicle) else {
            onFinish(false)
            return
        }
        
        vehicles.insert(vehicle)
        onFinish(true)
    }
    
    mutating func checkOutVehicle(plate : String, onSuccess : (Int) -> Void, onError : () -> Void, checkOut : Date){
    
        for var vehicle in vehicles {
            
            if(vehicle.plate == plate){
                vehicle.checkOutTime = checkOut
                var valueToPay : Int
                
                valueToPay = calculateFee(vehicleType: vehicle.type, parkedTime: vehicle.parkedTime, hasDiscountCard: vehicle.discountCard)
                
                vehicles.remove(vehicle)
                onSuccess(valueToPay)
                return
            }
        }
        onError()
    }
    
    mutating func calculateFee(vehicleType : VehicleType, parkedTime : Int, hasDiscountCard : String?) -> Int{
        
        var fee = vehicleType.rate
        
        if (parkedTime > 120){
            let reminderMins = parkedTime - 120
            fee += Int(ceil(Double(reminderMins) / 15.0)) * 5
        }
        if hasDiscountCard != nil {
            fee = Int(Double(fee) * 0.85)
        }
        
        totalFee = totalFee + fee
        totalVehicles = totalVehicles + 1

        return fee
    }
    
    mutating func totalFeeXVehicles() -> (Int, Int){
        let feeXvehicles : (Int, Int) = (totalFee, totalVehicles)
        
        return feeXvehicles
    }
    
    func plateList(){
        print("Vehicles in Parking...")
        if(vehicles.count > 0){
            for vehicle in vehicles {
                print(vehicle.plate)
            }
        }else{
            print("There are no vehicles in the parking lot")
        }

    }
}



//MARK: Vehicle Struct
struct Vehicle: Parkable, Hashable {
    var plate: String
    let type : VehicleType
    var checkInTime : Date
    var checkOutTime: Date?
    var discountCard : String?
    var parkedTime: Int {
        if let checkOut = checkOutTime {
            return Calendar.current.dateComponents([.minute], from: checkInTime, to: checkOut).minute ?? 0
        }
        return 0
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}



//Logic

var alkeParking = Parking()

var myVehicles : [Vehicle] = [
Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date.createDate(hour: 18, mins: 00), discountCard: "DISCOUNT_CARD_001"),
Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date.createDate(hour: 16, mins: 40), discountCard: nil),
Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 15, mins: 10), discountCard: nil),
Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date.createDate(hour: 12, mins: 40), discountCard: "DISCOUNT_CARD_002"),
Vehicle(plate: "AA111BB", type: VehicleType.car, checkInTime: Date.createDate(hour: 11, mins: 50), discountCard: "DISCOUNT_CARD_003"),
Vehicle(plate: "B222CCC", type: VehicleType.moto, checkInTime: Date.createDate(hour: 07, mins: 01), discountCard: "DISCOUNT_CARD_004"),
Vehicle(plate: "CC333DD", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 08, mins: 40), discountCard: nil),
Vehicle(plate: "DD444EE", type: VehicleType.bus, checkInTime: Date.createDate(hour: 06, mins: 10), discountCard: "DISCOUNT_CARD_005"),
Vehicle(plate: "AA111CC", type: VehicleType.car, checkInTime: Date.createDate(hour: 12, mins: 01), discountCard: nil),
Vehicle(plate: "B222DDD", type: VehicleType.moto, checkInTime: Date.createDate(hour: 14, mins: 40), discountCard: nil),
Vehicle(plate: "CC333EE", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 16, mins: 10), discountCard: nil),
Vehicle(plate: "DD444GG", type: VehicleType.bus, checkInTime: Date.createDate(hour: 13, mins: 30), discountCard: "DISCOUNT_CARD_006"),
Vehicle(plate: "AA111DD", type: VehicleType.car, checkInTime: Date.createDate(hour: 11, mins: 20), discountCard: "DISCOUNT_CARD_007"),
Vehicle(plate: "B222EEE", type: VehicleType.moto, checkInTime: Date.createDate(hour: 16, mins: 10), discountCard: nil),
Vehicle(plate: "CC333FF", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 12, mins: 0), discountCard: nil),
Vehicle(plate: "CC333SF", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 14, mins: 10), discountCard: nil),
Vehicle(plate: "DD2244F", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 12, mins: 40), discountCard: "DISCOUNT_CARD_008"),
Vehicle(plate: "EE2244F", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 12, mins: 45), discountCard: nil),
Vehicle(plate: "FF2244F", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 12, mins: 30), discountCard: nil),
Vehicle(plate: "GG2244F", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 12, mins: 20), discountCard: "DISCOUNT_CARD_009"),
Vehicle(plate: "HH2244F", type: VehicleType.miniBus, checkInTime: Date.createDate(hour: 11, mins: 00), discountCard: nil)]

//Insert Vehicles
for vehicle in myVehicles {
    alkeParking.checkInVehicle(vehicle: vehicle) { inserted in
        if inserted{
            print("Welcome to AlkeParking!")
        }else{
            print("Sorry, the check-in failed")
        }
    }
}

//CheckOut Vehicle
alkeParking.checkOutVehicle(plate: "AA111AA", onSuccess: { fee in
    print("Your fee is $\(fee)")
}, onError: {
    print("Sorry, the check-out failed")
}, checkOut : Date.createDate(hour: 19, mins: 00))

alkeParking.checkOutVehicle(plate: "B222BBB", onSuccess: { fee in
    print("Your fee is $\(fee)")
}, onError: {
    print("Sorry, the check-out failed")
}, checkOut : Date.createDate(hour: 24, mins: 00))

alkeParking.checkOutVehicle(plate: "GG2244F", onSuccess: { fee in
    print("Your fee is $\(fee)")
}, onError: {
    print("Sorry, the check-out failed")
}, checkOut : Date.createDate(hour: 15, mins: 00))



//Total Earnings for Vehicle
print("\(alkeParking.totalFeeXVehicles().1) vehicles have checked out and have earnings of $\(alkeParking.totalFeeXVehicles().0)")
    
