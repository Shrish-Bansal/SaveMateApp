import SwiftUI

struct LaunchScreenView: View {
    @State private var randomTip: String = ""

    // Function to get a random tip from the list
    func getRandomTip() {
        randomTip = FinancialTips.tips.randomElement() ?? "Stay on top of your finances!"
    }

    var body: some View {
        ZStack {
            // Background color or image for your launch screen
            Color("MainBackground").edgesIgnoringSafeArea(.all)

            VStack {
                // Optionally add a logo or any branding here
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.green)
                    .padding(.bottom, 30)

                // Display the random financial tip
                Text(randomTip)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Texts"))
                    .padding(.horizontal, 20)

            }
            .onAppear {
                getRandomTip()
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}

struct FinancialTips {
    static let tips = [
        "Track your expenses to understand where your money goes.",
        "Always pay off high-interest debt first.",
        "Set up an emergency fund for unexpected expenses.",
        "Invest early to take advantage of compound interest.",
        "Use a budget to make sure you are saving enough each month.",
        "Cut unnecessary subscriptions to save more money.",
        "Start saving for retirement as early as possible.",
        "Build and maintain a good credit score for better financial opportunities.",
        "Avoid impulse buying by waiting 24 hours before making a purchase.",
        "Review your financial goals and adjust them as needed regularly.",
        "Make a list before shopping to avoid buying things you don't need.",
        "Automate your savings to make sure you are consistently saving.",
        "Always shop around for the best deals and compare prices before buying.",
        "Contribute to your employer’s retirement plan, especially if they match your contributions.",
        "Minimize lifestyle inflation by keeping your expenses low as your income increases.",
        "Avoid using credit cards for non-essential purchases.",
        "Consider investing in index funds for long-term growth.",
        "Pay yourself first by saving a portion of your income before paying bills.",
        "Consider a high-yield savings account for better interest rates on savings.",
        "Don’t put all your investments in one basket—diversify your portfolio.",
        "Review your insurance policies regularly to ensure they are still adequate.",
        "Take advantage of tax-advantaged accounts like IRAs and 401(k)s.",
        "Keep a financial journal to track your income, expenses, and goals.",
        "Learn the basics of investing before you start—knowledge is key.",
        "Avoid payday loans—they often come with exorbitant interest rates.",
        "Refinance loans when interest rates are low to save money on repayments.",
        "Consider using cash instead of credit for certain purchases to stay within your budget.",
        "Set up automatic bill payments to avoid late fees.",
        "Reevaluate your subscriptions annually to cancel what you don’t use.",
        "Negotiate bills and contracts where possible to lower your monthly expenses.",
        "Avoid buying things on impulse by creating a waiting period for purchases.",
        "Consider using the 50/30/20 rule for budgeting—50% needs, 30% wants, 20% savings.",
        "Build your credit history responsibly by paying off credit cards on time.",
        "Don’t rely solely on credit cards—use cash for small, everyday purchases.",
        "Be mindful of your financial goals and break them down into smaller, achievable steps.",
        "Use coupons and cashback apps to save money on everyday purchases.",
        "Review your credit report regularly to catch any errors or fraudulent activity.",
        "Set a financial goal to save a certain percentage of your income each year.",
        "Keep an eye on inflation and adjust your spending habits accordingly.",
        "Seek professional advice if you’re unsure about investment or tax planning.",
        "Build multiple streams of income to protect yourself from financial setbacks.",
        "Use a debt snowball or avalanche method to pay off your debt more efficiently.",
        "Check your bank and credit card statements regularly for unexpected charges.",
        "Take advantage of employer-sponsored benefits, such as health insurance or wellness programs.",
        "Plan ahead for big purchases and save up rather than financing them.",
        "Keep an eye on your credit utilization ratio to maintain a healthy credit score.",
        "Don’t be afraid to ask for a raise or negotiate a better salary based on your performance.",
        "Start small with investing—don’t let fear hold you back from entering the market.",
        "Use financial apps to track your spending, saving, and investments.",
        "Learn to distinguish between ‘needs’ and ‘wants’ when making financial decisions.",
        "Avoid debt consolidation loans if the interest rate is higher than your current debts.",
        "Ensure that your will and estate planning are up to date to protect your assets.",
        "Consider a side hustle or freelance work to increase your income.",
        "Research any investment opportunities thoroughly before committing your money.",
        "Avoid buying brand-new items if you can get them used or refurbished at a lower price.",
        "Don't ignore your retirement—save and invest regularly for your future.",
        "Invest in your financial education to make smarter decisions with your money.",
        "Have a contingency plan in case of job loss or unexpected financial hardships.",
        "Look for ways to lower your energy and utility costs at home to save on monthly bills.",
        "Take advantage of cashback rewards and credit card perks when used responsibly.",
        "Reevaluate your financial plan periodically to make sure it aligns with your current goals.",
        "Use financial software or apps to keep track of your assets, liabilities, and net worth.",
        "Consider the long-term financial impact of your purchases before making them.",
        "Set a savings goal for every major life event, such as buying a house or starting a family.",
        "Always look for ways to reduce recurring costs, such as negotiating your rent or mortgage.",
        "Consider switching to a lower-cost cell phone plan or internet provider to save money.",
        "Don't be afraid to ask for discounts, especially for large purchases or long-term commitments.",
        "Create a financial calendar with due dates for bills, savings targets, and goals.",
        "Consider an online savings account for better interest rates and flexibility.",
        "Focus on building a financial cushion before pursuing risky investments.",
        "Stay disciplined with your spending, especially during holidays or special events.",
        "Keep emergency savings separate from your regular savings to avoid dipping into it unnecessarily.",
        "Teach your children about money management early to set them up for financial success."
    ]
}
