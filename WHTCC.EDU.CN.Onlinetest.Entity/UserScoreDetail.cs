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
    
    public partial class UserScoreDetail
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int UserAuthorityId { get; set; }
        public System.DateTime UserScoreDetailTime { get; set; }
    
        public virtual UserAuthority UserAuthority { get; set; }
        public virtual Users Users { get; set; }
    }
}
