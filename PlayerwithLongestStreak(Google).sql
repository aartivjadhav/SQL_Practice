-- # Player with Longest Streak

-- # You are given a table of tennis players and their matches that they could either win (W) or lose (L). 
-- # Find the longest streak of wins. A streak is a set of consecutive won matches of one player. 
-- # The streak ends once a player loses their next match.

-- # For this question, disregard edge cases such as: players who never lose, streaks that start before the first loss, and streaks that 
-- # continue after the final match.

WITH loss_groups AS (
    SELECT 
        player_id,
        match_result,
        -- Count losses up to the current row to form group identifiers for consecutive wins
        SUM(CASE WHEN match_result = 'L' THEN 1 ELSE 0 END) OVER (
            PARTITION BY player_id 
            ORDER BY match_date
        ) AS loss_group
    FROM players_results
),
streak_lengths AS (
    SELECT 
        player_id,
        COUNT(*) AS streak
    FROM loss_groups
    WHERE match_result = 'W'
    GROUP BY player_id, loss_group
)
SELECT 
    player_id,
    MAX(streak) AS longest_streak
FROM streak_lengths
GROUP BY player_id;


