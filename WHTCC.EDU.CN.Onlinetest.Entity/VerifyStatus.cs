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
    
    public partial class VerifyStatus
    {
        public int Id { get; set; }
        public int QuestionId { get; set; }
        public int UserId { get; set; }
        public bool Stamp { get; set; }
        public System.DateTime VerifyTime { get; set; }
        public Nullable<int> NewQuestinId { get; set; }
        public string Remark { get; set; }
    
        public virtual QuestionFORGeneral QuestionFORGeneral { get; set; }
        public virtual QuestionFORGeneral QuestionFORGeneral1 { get; set; }
        public virtual Users Users { get; set; }
    }
}
