import express from 'express'
const router = express()
import { userCtrl }  from '../controllers/userCtrl.js'
import { entryCtrl }  from '../controllers/entryCtrl.js'
import { tagCtrl }  from '../controllers/tagCtrl.js'
import { authenticate } from '../middlewares/authenticate.js'

router.post('/login', userCtrl.login);
router.post('/logout', authenticate, userCtrl.logout);
router.post('/', userCtrl.postUser);
// router.get('/', authenticate, userCtrl.getUser);
// router.put('/', authenticate, userCtrl.putUser);
// router.delete('/', authenticate, userCtrl.deleteUser);

router.get('/entries', authenticate, entryCtrl.getEntriesOfUser);
router.post('/entries', authenticate, entryCtrl.postEntry);
// router.get('/entries/:entryId', authenticate, entryCtrl.getOneEntryOfUser);
router.put('/entries/:entryId', authenticate, entryCtrl.putEntry);
router.get('/entries/dateRange', authenticate, entryCtrl.getEntriesWithDateRange);
// router.delete('/entries/:entryId', authenticate, entryCtrl.deleteEntry);

// router.get('/tags', authenticate, tagCtrl.getTagsOfUser);
router.get('/recent/tags', authenticate, tagCtrl.getRecentTags);
router.get('/table/tags', authenticate, tagCtrl.getTableTags);
router.get('/insightAll/tags', authenticate, tagCtrl.getAllInsightTags)
router.get('/insight/tags', authenticate, tagCtrl.getInsightTagsWithDateRange)
// router.post('/tags', authenticate, tagCtrl.postTag);
router.post('/entry/:entryId/tags', authenticate, tagCtrl.postTagToEntryAndUser);
router.put('/entry/:entryId/tags', authenticate, tagCtrl.putTags);
// router.get('/tags/:tagId', authenticate, tagCtrl.getOneTagOfUser);
// router.put('/tags/:tagId', authenticate, tagCtrl.putTag);
// router.delete('/tags/:tagId', authenticate, tagCtrl.deleteTag);

export { router }