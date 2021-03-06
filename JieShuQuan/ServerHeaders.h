//
//  ServerHeaders.h
//  JieShuQuan
//
//  Created by Jianning Zheng on 9/10/14.
//  Copyright (c) 2014 JNXZ. All rights reserved.
//

//#define kHost @"http://jieshuquan.herokuapp.com"
#define kHost @"http://localhost:3000"

#define kRegisterURL @"http://jieshuquan.herokuapp.com/register"
#define kLoginURL @"http://jieshuquan.herokuapp.com/login"
#define kUploadAvatarURL @"http://jieshuquan.herokuapp.com/upload_avatar"

#define kAvatarURLPrefix @"http://jieshuquan-ios.qiniudn.com/uploads%2FuserAvatar"

#define kAddBookURL @"http://jieshuquan.herokuapp.com/add_book"
#define kShareBookURL @"http://jieshuquan.herokuapp.com/book/"
#define kCollectBorrowingInfoURL @"http://jieshuquan.herokuapp.com/borrow_book"

#define kDeleteBookURL @"http://jieshuquan.herokuapp.com/remove_book"
#define kGetBookCommentsURL @"http://jieshuquan.herokuapp.com/comments_for_book/"
#define kPostBookCommentURL @"http://jieshuquan.herokuapp.com/comments/create"

#define kChangeBookStatusURL @"http://jieshuquan.herokuapp.com/change_status"
#define kChangeUserNameURL @"http://jieshuquan.herokuapp.com/change_username"
#define kChangeUserPhoneNumberURL @"http://jieshuquan.herokuapp.com/change_phone_number"
#define kChangeUserLocationURL @"http://jieshuquan.herokuapp.com/change_location"

#define kMyFriendsURL @"http://jieshuquan.herokuapp.com/friends_by_user/"
#define kMyBooksURL @"http://jieshuquan.herokuapp.com/books_by_user/"
#define kMyFriendsWithBookURL @"http://jieshuquan.herokuapp.com/friendsWithBook/"

// 借书申请
#define kCreateBorrowRecord @"/create_borrow_record"
#define kApproveBorrowRecord @"/approve_borrow_record"
#define kDeclineBorrowRecord @"/decline_borrow_record"
#define kReturnBorrowRecord @"/return_borrow_record"
#define kBorrowerRecords @"/borrower_records"
#define kLenderRecords @"/lender_records"
