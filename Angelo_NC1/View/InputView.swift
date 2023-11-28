//
//  InputView.swift
//  Angelo_NC1
//
//  Created by Angelo Kusuma on 05/05/23.
//

import SwiftUI

struct InputView: View {
    
    //Deklarasi
    @State private var data: [Finance] = []
    @State private var currentage: Double = 20
    @State private var retirementage: Double = 50
    @State private var employeeconti: Double = 30
    @State private var employeerconti: Double = 5
    @State private var interestrate: Double = 2
    @State private var inflationrate: Double = 5
    @State private var currentsaving: NSNumber = 0
    @State private var salaryincrease: Double = 5
    @State private var currentsalary: NSNumber = 48000000
    
    
    @State private var expenses: NSNumber = 24000000
    
    @State private var output: Double = 0
    @State private var years = 0
    
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }()
    
    @State private var buttonnext = true
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State private var offsetY: CGFloat = 0
    
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
                        Text("Retirement Planner")
                            .font(.custom("Arial", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
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
    
    //View Bawah
    @ViewBuilder
    func InputDataView() -> some View{
        VStack {
            
            //Bawah
            ZStack {
                Color.white
                    .ignoresSafeArea()
                ScrollView {
                    VStack{
                        //Current Age
                        Group{
                            VStack{
                                HStack{
                                    Text("Current Age")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(Years)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Age", value: $currentage, formatter: NumberFormatter())
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                        .multilineTextAlignment(.trailing)
                                    
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: $currentage, in: 17...100, step: 1))
                                    Slider(value: $currentage, in: 17...100, step: 1)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("17")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("100")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        //Age of Retirement
                        Group{
                            VStack{
                                HStack{
                                    Text("Age of Retirement")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(Years)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Age", value: $retirementage, formatter: NumberFormatter())
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 100)
                                    
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: $retirementage, in: 17...100, step: 1))
                                    Slider(value: $retirementage, in: 17...100, step: 1)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                            }
                            
                            HStack{
                                Text("17")
                                    .font(.custom("Arial", size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 16)
                                
                                Spacer()
                                
                                Text("100")
                                    .font(.custom("Arial", size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 16)
                            }
                        }
                        
                        //Annual Income
                        Group{
                            VStack{
                                HStack{
                                    Text("Current Salary")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(IDR/year)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Salary",
                                              value:Binding(
                                                get: { currentsalary.doubleValue },
                                                set: { currentsalary = NSNumber(value: $0)}),
                                              formatter: formatter)
                                    .font(.custom("Arial", size: 20))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.trailing, 16)
                                    .padding(.top, 16)
                                    .multilineTextAlignment(.trailing)
                                    
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: Binding(
                                        get: { currentsalary.doubleValue },
                                        set: { currentsalary = NSNumber(value: $0)}),
                                                 in: 0...1000000000, step: 1000000))
                                    Slider(value:  Binding(
                                        get: { currentsalary.doubleValue },
                                        set: { currentsalary = NSNumber(value: $0)}), in: 0...1000000000, step: 1000000)
                                    .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("Rp.0")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("Rp.1.000.000.000")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        //Expected Income Increase
                        Group{
                            VStack{
                                HStack{
                                    Text("Salary Increase")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(%/year)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    
                                    TextField("Salary", value: $salaryincrease, formatter: NumberFormatter())
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.top, 16)
                                        .padding(.trailing, -7)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width:100)
                                    
                                    Text("%")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: $salaryincrease, in: 0...1000, step: 1))
                                    Slider(value: $salaryincrease, in: 0...1000, step: 1)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("0%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("100%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        //Current Retirement Savings
                        Group{
                            VStack{
                                HStack{
                                    Text("Retirement Contribution")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(IDR)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Retire", value: $employeeconti, formatter: NumberFormatter())
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.top, 16)
                                        .padding(.trailing, -7)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width:100)
                                    
                                    Text("%")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: $employeeconti, in: 0...100, step: 1))
                                    Slider(value: $employeeconti, in: 0...100, step: 1)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("0%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("100%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        //Current Retirement Savings
                        Group{
                            VStack{
                                HStack{
                                    Text("Employer Contribution")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(IDR)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Salary", value: $employeerconti, formatter: NumberFormatter())
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.top, 16)
                                        .padding(.trailing, -7)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width:100)
                                    
                                    Text("%")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: $employeerconti, in: 0...100, step: 1))
                                    Slider(value: $employeerconti, in: 0...100, step: 1)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("0%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("100%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        
                        //Current Retirement Savings
                        Group{
                            VStack{
                                HStack{
                                    Text("Expected Rate of Return")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(IDR)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Salary", value: $interestrate, formatter: NumberFormatter())
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.top, 16)
                                        .padding(.trailing, -7)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width:100)
                                    
                                    Text("%")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: $interestrate, in: 0...100, step: 1))
                                    Slider(value: $interestrate, in: 0...100, step: 1)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("0%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("100%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        //Current Retirement Savings
                        Group{
                            VStack{
                                HStack{
                                    Text("Expected Inflation Rate")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(IDR)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Salary", value: $inflationrate, formatter: NumberFormatter())
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.top, 16)
                                        .padding(.trailing, -7)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width:100)
                                    
                                    Text("%")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: $inflationrate, in: 0...100, step: 1))
                                    Slider(value: $inflationrate, in: 0...100, step: 1)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("0%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("100%")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        //Current Retirement Savings
                        Group{
                            VStack{
                                HStack{
                                    Text("Annual Expenses")
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                    
                                    Text("(IDR)")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                        .padding(.top, 21)
                                    
                                    Spacer()
                                    
                                    TextField("Expenses",
                                              value:Binding(
                                                get: { expenses.doubleValue },
                                                set: { expenses = NSNumber(value: $0)}),
                                              formatter: formatter)
                                    .font(.custom("Arial", size: 20))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.trailing, 16)
                                    .padding(.top, 16)
                                    .multilineTextAlignment(.trailing)
                                }
                                ZStack{
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .mask(Slider(value: Binding(
                                        get: { expenses.doubleValue },
                                        set: { expenses = NSNumber(value: $0)}), in: 0...1000000000, step: 1000000))
                                    Slider(value: Binding(
                                        get: { expenses.doubleValue },
                                        set: { expenses = NSNumber(value: $0)}), in: 0...1000000000, step: 1000000)
                                        .opacity(0.05)
                                }
                                .padding(.horizontal, 16)
                                
                                HStack{
                                    Text("Rp.0")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("Rp.1.000.000.000")
                                        .font(.custom("Arial", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                        
                        //Current Retirement Savings
                        Group{
                            VStack {
                                VStack{
                                    HStack{
                                        Text("Current Savings")
                                            .font(.custom("Arial", size: 20))
                                            .foregroundColor(.black)
                                            .padding(.leading, 16)
                                            .padding(.top, 16)
                                        
                                        Text("(IDR)")
                                            .font(.custom("Arial", size: 10))
                                            .foregroundColor(.gray)
                                            .padding(.leading, -4)
                                            .padding(.top, 21)
                                        
                                        Spacer()
                                        
                                        TextField("Expenses",
                                                  value:Binding(
                                                    get: { currentsaving.doubleValue },
                                                    set: { currentsaving = NSNumber(value: $0)}),
                                                  formatter: formatter)
                                        .font(.custom("Arial", size: 20))
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 16)
                                        .padding(.top, 16)
                                        .multilineTextAlignment(.trailing)
                                    }
                                    ZStack{
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(red: 74/255, green: 105/255, blue: 188/255), Color(red: 81/255, green: 149/255, blue: 174/255)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        .mask(Slider(value: Binding(
                                            get: { currentsaving.doubleValue },
                                            set: { currentsaving = NSNumber(value: $0)}), in: 0...1000000000, step: 1000000))
                                        Slider(value: Binding(
                                            get: { currentsaving.doubleValue },
                                            set: { currentsaving = NSNumber(value: $0)}), in: 0...1000000000, step: 1000000)
                                            .opacity(0.05)
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    HStack{
                                        Text("Rp.0")
                                            .font(.custom("Arial", size: 10))
                                            .foregroundColor(.gray)
                                            .padding(.leading, 16)
                                        
                                        Spacer()
                                        
                                        Text("Rp.1.000.000.000")
                                            .font(.custom("Arial", size: 10))
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 16)
                                    }
                                }
                                
                                Button {
                                    count()
                                } label: {
                                    HStack {
                                        Text("Calculate")
                                            .foregroundColor(Color.blue)
                                            .bold()
                                    }
                                    .frame(width: 300, height: 30)
                                }
                                .padding(.top, 20.0)
                                .padding(.bottom, 30)
                                .tint(.gray)
                                .buttonStyle(.bordered)
                                
                                Button {
                                    nextpage()
                                } label: {
                                    HStack {
                                        Text("View Report")
                                            .foregroundColor(Color.blue)
                                            .bold()
                                    }
                                    .frame(width: 300, height: 30)
                                }
                                .disabled(buttonnext)
                                .padding(.top, 20.0)
                                .padding(.bottom, 30)
                                .tint(.gray)
                                .buttonStyle(.bordered)
                            }
                        }
                    }
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
    
    func count(){
        data.removeAll()
        var totalinterest: Double =  0
        var totalContributions: Double = 0
        let yearofretirement = retirementage - currentage
        var totalsavings: Double = 0
        
        for i in 1...Int(yearofretirement){
            let yearendsalary = currentsalary.doubleValue * pow(Double(1 + salaryincrease/100), Double(i))
            let employeecontribution = (employeeconti/100)*yearendsalary
            let employeercontribution = (employeerconti/100)*yearendsalary
            let totalcontribution = employeecontribution + employeercontribution
            totalContributions += totalcontribution
            
            let yearendinflation = pow(Double(1 + inflationrate/100), Double(i))
            let yearendinterest = (currentsaving.doubleValue + totalContributions) * interestrate/100 * yearendinflation
            totalinterest += yearendinterest
            
            totalsavings += currentsaving.doubleValue + totalContributions + yearendinterest
            //Total savings
            self.data.append(Finance(age: Double(i-1)+currentage, status: "working", savings: totalsavings, expenses: 0))
        }
        
        output = totalsavings
        
        var x = 0
        while(totalsavings > 0){
            let yearendinflation = pow(Double(1 + inflationrate/100), Double(x))
            let expensesincrease = Double(expenses) * yearendinflation
            var totalexpenses = Double(expenses) + expensesincrease
            var test = totalsavings - totalexpenses
            if (test <= 0){
                self.data.append(Finance(age: Double(x)+retirementage, status: "retired", savings: 0, expenses: Double(totalexpenses)))
                x+=1
                years+=1
                break
            }else{
                totalsavings -= totalexpenses
                self.data.append(Finance(age: Double(x)+retirementage, status: "retired", savings: totalsavings, expenses: Double(totalexpenses)))
                x+=1
                years+=1
            }
            
            
        }
        buttonnext = false
        print(totalsavings)
    }
    
    func nextpage(){
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: GraphView(inflationrate: inflationrate, output: output, years: years, data: data ,size: size, safeArea: safeArea))
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
