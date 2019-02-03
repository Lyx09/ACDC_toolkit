        public static void Announce(string str, ConsoleColor c)
        {
            Console.ForegroundColor = c;
            Console.WriteLine(str);
            Console.ResetColor();
        }

        public static void Main(string[] args)
        {
            User user = new User("Sophie");
            Bank bank = new Bank("EPITA");
            DAB dab = new DAB(bank);
            Inputs.init();


            Announce("--- INPUTS ---", ConsoleColor.Blue);
            Announce("[GetString]", ConsoleColor.Blue);
            Announce("try \"\", \"a\"", ConsoleColor.Yellow);
            string str = Inputs.GetString("Test");
            Console.WriteLine("str is equal to: " + str);
            Announce("Expected: a", ConsoleColor.Cyan);

            Announce("[GetUint]", ConsoleColor.Blue);
            Announce("try \"\", \"hsdis\", \"-1\", \"42\"", ConsoleColor.Yellow);
            uint num = Inputs.GetUInt("Test");
            Console.WriteLine("num is equal to: " + num);
            Announce("Expected: 42", ConsoleColor.Cyan);

            Announce("[GetUser]", ConsoleColor.Blue);
            Announce("try \"\", \"ACDC\", \"Sophie\"", ConsoleColor.Yellow);
            user = Inputs.GetUser();
            Console.WriteLine("user.name is equal to: " + user.name);
            Announce("Expected: Sophie", ConsoleColor.Cyan);

            Announce("[GetDab]", ConsoleColor.Blue);
            Announce("try \"\", \"sadad\", \"-1\", \"0\"", ConsoleColor.Yellow);
            dab = Inputs.GetDAB();
            Console.WriteLine("dab.uid is equal to: " + dab.uid);
            Announce("Expected: 0", ConsoleColor.Cyan);

            Announce("[GetBank]", ConsoleColor.Blue);
            Announce("try \"\", \"asdjak\", \"ACDC\"", ConsoleColor.Yellow);
            bank = Inputs.GetBank();
            Console.WriteLine("bank.name is equal to: " + bank.name);
            Announce("Expected: ACDC", ConsoleColor.Cyan);






            Announce("--- USER ---", ConsoleColor.Blue);
            Announce("[JoinBank]", ConsoleColor.Blue);
            user.JoinBank(bank);
            Console.WriteLine("user.bank is equal to: " + user.bank.name);
            Announce("Expected: EPITA", ConsoleColor.Cyan);

            Announce("[DisplayUserInfo]", ConsoleColor.Blue);
            user.DisplayUserInfo();
            Announce("Expected: EPITA", ConsoleColor.Cyan);






            Announce("--- BANK ---", ConsoleColor.Blue);
            Announce("[GetMoneyOf]", ConsoleColor.Blue);
            Console.WriteLine("Sophie's money: " + bank.GetMoneyOf(user));
            Announce("Expected: FIXME", ConsoleColor.Yellow);

            Announce("[AddUser]", ConsoleColor.Blue);
            User u = new User("Calcifer");
            bank.AddUser(u);
            Console.WriteLine("bank[user] is equal to: " + bank.users[user]);
            Announce("Expected: FIXME", ConsoleColor.Cyan);
            Console.WriteLine("user.bank is equal to: " + user.bank.name);
            Announce("Expected: EPITA", ConsoleColor.Cyan);

            Announce("[AllowWithdraw 2000]", ConsoleColor.Blue);
            Console.WriteLine("Sophie's money: " + bank.GetMoneyOf(user));
            Announce("Expected: FIXME", ConsoleColor.Cyan);
            Console.WriteLine("allow withdraw ? " + bank.AllowWithdraw(user, 2000));
            Announce("Expected: FIXME", ConsoleColor.Cyan);

            Announce("[Deposit 500]", ConsoleColor.Blue);
            Console.WriteLine("Sophie's money: " + bank.GetMoneyOf(user));
            bank.Deposit(user, 1000);
            Console.WriteLine("Sophie's money: " + bank.GetMoneyOf(user));
            Announce("Expected: FIXME", ConsoleColor.Cyan);

            Announce("[Withdraw]", ConsoleColor.Blue);
            Console.WriteLine("Sophie's money: " + bank.GetMoneyOf(user));
            bank.Withdraw(user, 100);
            Console.WriteLine("Sophie's money: " + bank.GetMoneyOf(user));
            Announce("Expected: FIXME", ConsoleColor.Cyan);

            Announce("[DisplayBankInfo]", ConsoleColor.Blue);
            user.DisplayUserInfo();




            Announce("--- DAB ---", ConsoleColor.Blue);
            Announce("[Fill]", ConsoleColor.Blue);
            Console.WriteLine("Money left in the DAB: " + dab.moneyLeft);
            dab.Fill(1000);
            Console.WriteLine("Money left in the DAB: " + dab.moneyLeft);
            Announce("Expected: FIXME", ConsoleColor.Cyan);

            Announce("[AllowWithdraw]", ConsoleColor.Blue);
            Console.WriteLine("dab.bank.name is equal to: " + dab.bank.name);
            Console.WriteLine("Sophie's money: " + dab.bank.GetMoneyOf(user));
            Console.WriteLine("allow withdraw ? " + dab.AllowWithdraw(user, 2000));
            Announce("Expected: FIXME", ConsoleColor.Cyan);

            Announce("[Withdraw]", ConsoleColor.Blue);
            Console.WriteLine("Sophie's money: " + dab.bank.GetMoneyOf(user));
            Console.WriteLine("Money left in the DAB: " + dab.moneyLeft);
            dab.Withdraw(user, 100);
            Console.WriteLine("Sophie's money: " + dab.bank.GetMoneyOf(user));
            Console.WriteLine("Money left in the DAB: " + dab.moneyLeft);
            Announce("Expected: FIXME", ConsoleColor.Cyan);

            Announce("[AllowDeposit]", ConsoleColor.Blue);
            Console.WriteLine("dab.bank.name is equal to: " + dab.bank.name);
            Console.WriteLine("user.bank.name is equal to: " + user.bank.name);
            Console.WriteLine("allow deposit ? " + dab.AllowDeposit(user));
            Announce("Expected: FIXME", ConsoleColor.Cyan);

            Announce("[Deposit]", ConsoleColor.Blue);
            Console.WriteLine("Sophie's money: " + dab.bank.GetMoneyOf(user));
            Console.WriteLine("Money left in the DAB: " + dab.moneyLeft);
            dab.Deposit(user, 1000);
            Console.WriteLine("Sophie's money: " + dab.bank.GetMoneyOf(user));
            Console.WriteLine("Money left in the DAB: " + dab.moneyLeft);

            Announce("[DisplayDABInfo]", ConsoleColor.Blue);
            dab.DisplayDABInfo();






            Announce("--- Handling ---", ConsoleColor.Blue);
            Announce("[Handling]", ConsoleColor.Blue);
            Inputs.Init();
            Announce("try Sophie,0,100", ConsoleColor.Yellow);
            HandleDeposit();
            Announce("try Sophie,2,100", ConsoleColor.Yellow);
            HandleDeposit();

            Announce("[HandleWithdraw]", ConsoleColor.Blue);
            Announce("try Sophie,0,100", ConsoleColor.Yellow);
            HandleWithdraw();
            Announce("try Sophie,0,999999", ConsoleColor.Yellow);
            HandleWithdraw();
            Announce("try Sophie,2,100", ConsoleColor.Yellow);
            HandleWithdraw();

            Announce("[HandleUserInfo]", ConsoleColor.Blue);
            Announce("try Jojo, Sophie", ConsoleColor.Yellow);
            HandleUserInfo();

            Announce("[HandleDABInfo]", ConsoleColor.Blue);
            Announce("try 2000, 0", ConsoleColor.Yellow);
            HandleDABInfo();

            Announce("[HandleBankInfo]", ConsoleColor.Blue);
            Announce("try ASM, ACDC", ConsoleColor.Yellow);
            HandleBankInfo();

        }
