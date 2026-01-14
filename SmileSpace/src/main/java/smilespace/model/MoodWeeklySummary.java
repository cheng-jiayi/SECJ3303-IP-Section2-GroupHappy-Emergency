package smilespace.model;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class MoodWeeklySummary {
    private LocalDate weekStart;
    private LocalDate weekEnd;
    private int totalEntries;
    private Map<String, Integer> feelingFrequency;
    private List<String> dominantFeelings;

    public LocalDate getWeekStart() { return weekStart; }
    public void setWeekStart(LocalDate weekStart) { this.weekStart = weekStart; }

    public LocalDate getWeekEnd() { return weekEnd; }
    public void setWeekEnd(LocalDate weekEnd) { this.weekEnd = weekEnd; }

    public int getTotalEntries() { return totalEntries; }
    public void setTotalEntries(int totalEntries) { this.totalEntries = totalEntries; }

    public Map<String, Integer> getFeelingFrequency() { return feelingFrequency; }
    public void setFeelingFrequency(Map<String, Integer> feelingFrequency) { this.feelingFrequency = feelingFrequency; }

    public List<String> getDominantFeelings() { return dominantFeelings; }
    public void setDominantFeelings(List<String> dominantFeelings) { this.dominantFeelings = dominantFeelings; }

    public String getFormattedWeekRange() {
        return weekStart.getDayOfMonth() + " " + weekStart.getMonth().toString().substring(0, 3) + 
               " - " + weekEnd.getDayOfMonth() + " " + weekEnd.getMonth().toString().substring(0, 3) + " " + weekEnd.getYear();
    }
}