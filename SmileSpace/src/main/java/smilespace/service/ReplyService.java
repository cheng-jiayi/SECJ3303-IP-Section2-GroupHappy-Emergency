package smilespace.service;

import smilespace.model.Reply;
import java.util.List;

public interface ReplyService {
    List<Reply> getRepliesByPostId(int postId);
    void createReply(Reply reply);
    void updateReply(Reply reply);
    void deleteReply(int replyId, int userId); // Only owner
    Reply getReplyById(int replyId);
}
