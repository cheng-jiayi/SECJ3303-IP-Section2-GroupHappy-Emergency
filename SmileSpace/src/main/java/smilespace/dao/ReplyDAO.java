package smilespace.dao;

import smilespace.model.Reply;
import java.util.List;

public interface ReplyDAO {
    List<Reply> getRepliesByPostId(int postId);
    void createReply(Reply reply);
    void updateReply(Reply reply);
    void deleteReply(int replyId);
    Reply getReplyById(int replyId);
}
