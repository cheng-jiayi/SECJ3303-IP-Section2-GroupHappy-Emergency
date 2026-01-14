package smilespace.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import smilespace.model.MoodEntry;
import smilespace.model.MoodWeeklySummary;
import smilespace.dao.MoodDAO;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Service
public class MoodService {
    
    @Autowired
    private MoodDAO moodDAO;
    
    public boolean createMoodEntry(MoodEntry entry) {
        return moodDAO.createMoodEntry(entry);
    }
    
    public MoodEntry getMoodEntryById(int entryId, int userId) {
        return moodDAO.getMoodEntryById(entryId, userId);
    }
    
    public MoodEntry getMoodEntryByDate(int userId, LocalDate date) {
        return moodDAO.getMoodEntryByDate(userId, date);
    }
    
    public List<MoodEntry> getMoodEntriesByUser(int userId) {
        return moodDAO.getMoodEntriesByUser(userId);
    }
    
    public boolean updateMoodEntry(MoodEntry entry) {
        return moodDAO.updateMoodEntry(entry);
    }
    
    public boolean deleteMoodEntry(int entryId, int userId) {
        return moodDAO.deleteMoodEntry(entryId, userId);
    }
    
    public MoodEntry getLatestMoodEntry(int userId) {
        return moodDAO.getLatestMoodEntry(userId);
    }
    
    public MoodWeeklySummary getWeeklySummary(int userId, LocalDate date) {
        return moodDAO.getWeeklySummary(userId, date);
    }
    
    public Map<String, Integer> getMoodTrends(int userId) {
        return moodDAO.getMoodTrends(userId);
    }
}