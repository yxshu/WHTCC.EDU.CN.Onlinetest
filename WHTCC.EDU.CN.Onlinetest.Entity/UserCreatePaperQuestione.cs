//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace WHTCC.EDU.CN.Onlinetest.Entity
{
    using System;
    using System.Collections.Generic;
    
    public partial class UserCreatePaperQuestione
    {
        public int Id { get; set; }
        public int UserCreatePaperId { get; set; }
        public int QuestionId { get; set; }
    
        public virtual QuestionFORGeneral QuestionFORGeneral { get; set; }
        public virtual UserCreatePaper UserCreatePaper { get; set; }
    }
}