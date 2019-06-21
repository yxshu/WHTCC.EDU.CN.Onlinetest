using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WHTCC.EDU.CN.Onlinetest.Entity;

namespace TEST
{
    class Program
    {
        static void Main(string[] args)
        {
            DataEntityConn context = new DataEntityConn();
            Console.WriteLine(context.Chapter.Count());
            Console.ReadLine();

        }
    }
}
