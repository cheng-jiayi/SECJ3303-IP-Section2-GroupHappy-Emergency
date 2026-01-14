package smilespace.service;

import smilespace.dao.ReplyDAO;
import smilespace.model.Reply;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReplyServiceImpl implements ReplyService {

    private final ReplyDAO replyDAO;

    public ReplyServiceImpl(ReplyDAO replyDAO) {
        this.replyDAO = replyDAO;
    }

    @Override
    public List<Reply> getRepliesByPostId(int postId) {
        return replyDAO.getRepliesByPostId(postId);
    }

    @Override
    public void createReply(Reply reply) {
        replyDAO.createReply(reply);
    }

    @Override
    public void updateReply(Reply reply) {
        replyDAO.updateReply(reply);
    }

    @Override
    public void deleteReply(int replyId, int userId) {
        // Fetch reply from DAO
        Reply reply = replyDAO.getReplyById(replyId);

        // Only delete if the logged-in user is the owner
        if (reply != null && reply.getUserId() == userId) {
            replyDAO.deleteReply(replyId); // call DAO to delete
        }
    }

    @Override
    public Reply getReplyById(int replyId) {
        return replyDAO.getReplyById(replyId);
    }
}
