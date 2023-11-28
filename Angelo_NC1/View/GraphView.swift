//
//  GraphView.swift
//  Angelo_NC1
//
//  Created by Angelo Kusuma on 15/05/23.
//

import SwiftUI
import Charts




struct GraphView: View {
    
    var inflationrate: Double
    var output: Double
    var years: Int
    
    var data: [Finance]
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State private var offsetY: CGFloat = 0
    let titles = ["Age", "Expenses", "Savings"]
    
    
    
    var body: some View {
        
        
        
        
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0){
                    HeaderView()
                        .zIndex(1000)
                    InputDataView()
                }
                .id("SCROLLVIEW")
                .background{
                    ScrollDetector {offset in
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        let headerheight = (size.height * 0.3) + safeArea.top
                        let minimumHeaderHeight = 65 + safeArea.top
                        
                        let targetEnd = offset + (velocity * 45)
                        if targetEnd < (headerheight - minimumHeaderHeight) && targetEnd > 0 {
                            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration: 0.65)){
                                scrollProxy.scrollTo("SCROLLVIEW", anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Header View
    @ViewBuilder
    func HeaderView() -> some View{
        let headerheight = (size.height * 0.3) + safeArea.top + 50
        let minimumHeaderHeight = 30 + safeArea.top
        let progress = max(min(-offsetY / (headerheight - minimumHeaderHeight), 1), 0)
        GeometryReader { _ in
            //Atas
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                VStack{
                    ZStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 15, height: 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .foregroundColor(.white)
                            .onTapGesture {
                                GoBack()
                            }
                        
                        Text("Retirement Planner")
                            .font(.custom("Arial", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    
                    //Card View
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.white)
                        
                        VStack {
                            GeometryReader {
                                let rect = $0.frame(in: .global)
                                let halfScaledHeight = (rect.height * 0.3) * 0.5
                                let midY = rect.midY
                                let bottomPadding: CGFloat = 15
                                let resizedOffsetY = (midY - (minimumHeaderHeight - halfScaledHeight - bottomPadding)) + 7
                                
                                HStack {
                                    Spacer()
                                    Text("\(createFormatter(value:output))")
                                        .foregroundColor(progress > 0.5 ? .white : .black)
                                        .font(.custom("Arial", size: 30))
                                        .scaleEffect(1 - (progress * 0.3), anchor: .center)
                                    
                                    //                                    .padding(.leading, headerheight * 0.2)
                                        .offset( y: -resizedOffsetY * progress)
                                        .multilineTextAlignment(.center)
                                        .bold()
                                    Spacer()
                                }
                            }
                            
                            
                            Text("Est. Fund Saved")
                                .foregroundColor(.gray)
                                .font(.custom("Arial", size: 20))
                                .padding(.bottom, 5)
                            
                            HStack{
                                Text("Inflation Rate")
                                    .foregroundColor(.gray)
                                    .font(.custom("Arial", size: 15))
                                    .padding(.leading, 30)
                                
                                Spacer()
                                
                                Text("\(String(format: "%.0f", inflationrate))")
                                    .foregroundColor(.gray)
                                    .font(.custom("Arial", size: 15))
                                    .padding(.trailing, 30)
                            }
                            
                            HStack{
                                Text("Est. Funds Last For")
                                    .foregroundColor(.gray)
                                    .font(.custom("Arial", size: 15))
                                    .padding(.leading, 30)
                                
                                Spacer()
                                
                                Text("\(years) years")
                                    .foregroundColor(.gray)
                                    .font(.custom("Arial", size: 15))
                                    .padding(.trailing, 30)
                            }
                        }
                        .padding(20)
                        .multilineTextAlignment(.center)
                    }
                    .frame(width: (headerheight - 50) * 1.2, height: (headerheight - 50) * 0.5)
                    
                    
                }
                .padding(.top, safeArea.top)
                .padding(.bottom, 90)
            }
            .frame(height: (headerheight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerheight + offsetY), alignment: .bottom)
            .offset(y: -offsetY)
        }
        .frame(height: headerheight)
    }
    
    //Bawah
    @ViewBuilder
    func InputDataView() -> some View{
        VStack {
            Chart {
                ForEach(data) {
                    AreaMark(
                        x: .value("currentage", $0.age),
                        y: .value("Savings", $0.savings)
                    )
                    .foregroundStyle(by: .value("Status", "Series \($0.status)"))
                }
            }
            .padding()
            .frame(height: 250)
            
            HStack {
                ForEach(titles, id: \.self) { title in
                    Text(title)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                        .bold()
                    Divider()
                }
            }
            
            ForEach(data) { data in
                HStack {
                    Group {
                        Text(String(data.age))
                            .font(.system(size: 10))
                        Text("\(createFormatter(value:data.expenses))")
                            .font(.system(size: 10))
                        Text("\(createFormatter(value:data.savings))")
                            .font(.system(size: 10))
                            .foregroundColor(data.status == "retired" ? .red : .black)
                    }
                    .padding(.horizontal, 15)
                    .lineLimit(1)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        
        
    }
    
    func createFormatter(value: Double)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        let a = formatter.string(from: NSNumber(value: value)) ?? "-"
        return a
    }
    
    func GoBack(){
        print(data)
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: InputView(size: size, safeArea: safeArea))
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
